use prost::Message;
use sideswap_common::env::Env;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::str::FromStr;
use std::sync::Once;

use crate::worker;

pub mod proto {
    #![allow(non_snake_case)]

    include!(concat!(env!("OUT_DIR"), "/sideswap.proto.rs"));
}

pub type ToMsg = proto::to::Msg;
pub type FromMsg = proto::from::Msg;

static INIT_LOGGER_FLAG: Once = Once::new();

pub struct StartParams {
    pub work_dir: String,
    pub version: String,
    pub disable_device_key: Option<bool>,
}

pub struct Client {
    msg_sender: crossbeam_channel::Sender<worker::Message>,
    from_receiver_ffi: Option<crossbeam_channel::Receiver<FromMsg>>,
    env: Env,
}

pub struct RecvMessage(Vec<u8>);

// Send pointers to Dart as u64 (even on 32-bit platforms)
pub type IntPtr = u64;

// NOTE: Do not use usize for ffi, use u64 instead.
// Using usize breaks generated code on 32 builds (arm7).

// Client pointer to use from background notifications
static GLOBAL_CLIENT: std::sync::atomic::AtomicU64 = std::sync::atomic::AtomicU64::new(0);

fn get_string(str: *const c_char) -> String {
    let str = unsafe { std::ffi::CStr::from_ptr(str) };
    str.to_str().unwrap().to_owned()
}

fn convert_from_msg(msg: FromMsg) -> u64 {
    let from = proto::From { msg: Some(msg) };
    let mut buf = Vec::new();
    from.encode(&mut buf).expect("encoding message failed");
    let msg = std::boxed::Box::new(RecvMessage(buf));

    Box::into_raw(msg) as IntPtr
}

pub fn get_ffi_from_env(env: i32) -> Option<Env> {
    match env {
        SIDESWAP_ENV_PROD => Some(Env::Prod),
        SIDESWAP_ENV_STAGING => Some(Env::Staging),
        SIDESWAP_ENV_REGTEST => Some(Env::Regtest),
        SIDESWAP_ENV_LOCAL => Some(Env::Local),
        SIDESWAP_ENV_LOCAL_LIQUID => Some(Env::LocalLiquid),
        SIDESWAP_ENV_TESTNET => Some(Env::Testnet),
        SIDESWAP_ENV_LOCAL_TESTNET => Some(Env::LocalTestnet),
        _ => None,
    }
}

pub fn send_msg(client: IntPtr, msg: proto::to::Msg) {
    let msg = proto::To { msg: Some(msg) };
    let mut buf = Vec::new();
    msg.encode(&mut buf).expect("encoding message failed");
    sideswap_send_request(client, buf.as_ptr(), buf.len() as u64);
}

pub fn blocking_recv_msg(client: IntPtr) -> proto::from::Msg {
    let msg = sideswap_recv_request(client);
    let ptr = sideswap_msg_ptr(msg);
    let size = sideswap_msg_len(msg);
    let msg_copy = unsafe { std::slice::from_raw_parts(ptr, size as usize) }.to_owned();
    sideswap_msg_free(msg);
    let msg = proto::From::decode(msg_copy.as_slice()).expect("message decode failed");
    msg.msg.unwrap()
}

#[no_mangle]
pub extern "C" fn sideswap_client_start(
    env: i32,
    work_dir: *const c_char,
    version: *const c_char,
    dart_port: i64,
) -> IntPtr {
    let env = get_ffi_from_env(env).expect("unknown env");
    let work_dir = get_string(work_dir);
    let version = get_string(version);

    let start_params = StartParams {
        work_dir: work_dir.to_owned(),
        version: version.to_owned(),
        disable_device_key: None,
    };

    sideswap_client_start_impl(env, start_params, dart_port)
}

pub fn sideswap_client_start_impl(env: Env, start_params: StartParams, dart_port: i64) -> IntPtr {
    let enable_dart = dart_port != SIDESWAP_DART_PORT_DISABLED;

    INIT_LOGGER_FLAG.call_once(|| {
        init_log(&start_params.work_dir);
    });

    std::panic::set_hook(Box::new(|i| {
        error!("sideswap panic detected: {:?}", i);
        std::process::abort();
    }));

    info!(
        "started: {} ({}/{})",
        env!("VERGEN_GIT_SHA"),
        std::env::consts::OS,
        std::env::consts::ARCH,
    );

    let (msg_sender, msg_receiver) = crossbeam_channel::unbounded::<worker::Message>();
    let (from_sender, from_receiver) = crossbeam_channel::unbounded::<FromMsg>();

    let from_receiver_ffi = if enable_dart {
        None
    } else {
        Some(from_receiver.clone())
    };

    let client = Box::new(Client {
        env,
        msg_sender: msg_sender.clone(),
        from_receiver_ffi,
    });

    std::thread::Builder::new()
        .name("worker_rust".to_owned())
        .spawn(move || {
            worker::start_processing(env, msg_sender, msg_receiver, from_sender, start_params);
        })
        .unwrap();

    if enable_dart {
        std::thread::spawn(move || {
            let port = allo_isolate::Isolate::new(dart_port);
            for msg in from_receiver {
                let msg_ptr = convert_from_msg(msg);
                let result = port.post(msg_ptr);
                if !result {
                    warn!("posting message to dart failed, exit");
                    break;
                }
            }
        });
    }

    let client = Box::into_raw(client) as IntPtr;
    GLOBAL_CLIENT.store(client, std::sync::atomic::Ordering::Relaxed);
    client
}

#[no_mangle]
pub extern "C" fn sideswap_send_request(client: IntPtr, data: *const u8, len: u64) {
    assert!(client != 0);
    assert!(data != std::ptr::null());
    let client = unsafe { &mut *(client as *mut Client) };
    let slice = unsafe { std::slice::from_raw_parts(data, len as usize) };
    let to = proto::To::decode(slice).expect("message decode failed");
    let msg = to.msg.expect("empty message");
    client
        .msg_sender
        .send(worker::Message::Ui(msg))
        .expect("sending to message failed");
}

#[no_mangle]
pub extern "C" fn sideswap_recv_request(client: IntPtr) -> u64 {
    assert!(client != 0);
    let client = unsafe { &mut *(client as *mut Client) };
    let from_receiver_ffi = client
        .from_receiver_ffi
        .as_ref()
        .expect("sideswap_recv_request can't be used with dart");
    convert_from_msg(from_receiver_ffi.recv().unwrap())
}

#[no_mangle]
pub extern "C" fn sideswap_process_background(data: *const c_char) {
    let data = unsafe { CStr::from_ptr(data) }
        .to_str()
        .expect("invalid c-str")
        .to_owned();

    let client = GLOBAL_CLIENT.load(std::sync::atomic::Ordering::Relaxed);
    info!(
        "background message received, client: {}, data: {}",
        client, data
    );
    if client == 0 {
        return;
    }
    let client = unsafe { &mut *(client as *mut Client) };
    let (sender, receiver) = crossbeam_channel::unbounded();
    let started = std::time::Instant::now();
    client
        .msg_sender
        .send(worker::Message::BackgroundMessage(data, sender))
        .expect("sending to message failed");
    let wait_result = receiver.recv_timeout(std::time::Duration::from_secs(25));
    let time = std::time::Instant::now().duration_since(started);
    match wait_result {
        Ok(_) => info!(
            "background message processing done ({} seconds)",
            time.as_secs()
        ),
        Err(_) => warn!("wait timeout"),
    }
}

pub const SIDESWAP_DART_PORT_DISABLED: i64 = -1;

pub const SIDESWAP_BITCOIN: i32 = 1;
pub const SIDESWAP_ELEMENTS: i32 = 2;

pub const SIDESWAP_ENV_PROD: i32 = 0;
pub const SIDESWAP_ENV_STAGING: i32 = 1;
pub const SIDESWAP_ENV_REGTEST: i32 = 2;
pub const SIDESWAP_ENV_LOCAL: i32 = 3;
pub const SIDESWAP_ENV_LOCAL_LIQUID: i32 = 4;
pub const SIDESWAP_ENV_TESTNET: i32 = 5;
pub const SIDESWAP_ENV_LOCAL_TESTNET: i32 = 6;

#[no_mangle]
pub extern "C" fn sideswap_check_addr(client: IntPtr, addr: *const c_char, addr_type: i32) -> bool {
    assert!(client != 0);
    assert!(addr != std::ptr::null());
    let addr = unsafe { CStr::from_ptr(addr) }
        .to_str()
        .expect("invalid c-str");
    let client = unsafe { &mut *(client as *mut Client) };
    match addr_type {
        SIDESWAP_BITCOIN => check_bitcoin_address(client.env, addr),
        SIDESWAP_ELEMENTS => check_elements_address(client.env, addr),
        _ => panic!("unexpected type"),
    }
}

#[no_mangle]
pub extern "C" fn sideswap_msg_ptr(msg: IntPtr) -> *const u8 {
    assert!(msg != 0);
    let msg = unsafe { &*(msg as *const RecvMessage) };
    msg.0.as_ptr()
}

#[no_mangle]
pub extern "C" fn sideswap_msg_len(msg: IntPtr) -> u64 {
    assert!(msg != 0);
    let msg = unsafe { &*(msg as *const RecvMessage) };
    msg.0.len() as u64
}

#[no_mangle]
pub extern "C" fn sideswap_msg_free(msg: IntPtr) {
    assert!(msg != 0);
    let msg = unsafe { Box::from_raw(msg as *mut RecvMessage) };
    std::mem::drop(msg);
}

const ENTROPY_SIZE_MNEMONIC12: usize = 16;

fn generate_mnemonic12_from_rng<R: rand::RngCore + rand::CryptoRng>(rng: &mut R) -> String {
    let mut key: [u8; ENTROPY_SIZE_MNEMONIC12] = [0; ENTROPY_SIZE_MNEMONIC12];
    rng.try_fill_bytes(&mut key)
        .expect("generating random bytes failed");
    let mnemonic = bip39::Mnemonic::from_entropy(&key).expect("generating mnemonic failed");
    mnemonic.to_string()
}

#[no_mangle]
pub extern "C" fn sideswap_generate_mnemonic12() -> *mut c_char {
    let mut rng = rand::rngs::OsRng::default();
    let str = generate_mnemonic12_from_rng(&mut rng);
    let value = CString::new(str).unwrap();
    value.into_raw()
}

#[no_mangle]
pub extern "C" fn sideswap_verify_mnemonic(mnemonic: *const c_char) -> bool {
    let mnemonic = unsafe { CStr::from_ptr(mnemonic) };
    bip39::Mnemonic::parse(mnemonic.to_str().unwrap())
        .ok()
        .map(|mnemonic| mnemonic.word_count() == 12 || mnemonic.word_count() == 24)
        .unwrap_or(false)
}

#[no_mangle]
pub extern "C" fn sideswap_string_free(str: *mut c_char) {
    unsafe {
        drop(CString::from_raw(str));
    }
}

const LOG_FILTER: &str = "debug,hyper=info,rustls=info,ureq=warn";

pub const TIMESTAMP_FORMAT: &str = "%Y-%m-%d %H:%M:%S.%3f";

pub fn log_format(
    w: &mut dyn std::io::Write,
    now: &mut flexi_logger::DeferredNow,
    record: &log::Record,
) -> Result<(), std::io::Error> {
    let text = format!(
        "[{}] {} {} {}",
        now.format(TIMESTAMP_FORMAT),
        record.level(),
        record.module_path().unwrap_or("<unnamed>"),
        &record.args()
    );
    let line_limit = if cfg!(debug_assertions) {
        1024 * 1024
    } else {
        2 * 1024
    };
    let len = std::cmp::min(text.len(), line_limit);
    write!(w, "{}", &text.as_str()[..len])
}

pub fn init_log(work_dir: &str) {
    let path = format!("{}/{}", work_dir, "sideswap.log");

    let file_size = std::fs::metadata(&path)
        .map(|metadata| metadata.len())
        .unwrap_or_default();
    if file_size > 50 * 1024 * 1024 {
        let path_old = format!("{}/{}", work_dir, "sideswap_prev.log");
        let _ = std::fs::rename(&path, path_old);
    }

    let _ = flexi_logger::Logger::try_with_str(LOG_FILTER)
        .unwrap()
        .format(log_format)
        .use_utc()
        .log_to_file(flexi_logger::FileSpec::try_from(path).unwrap())
        .append()
        .duplicate_to_stderr(flexi_logger::Duplicate::Error)
        .start();
}

fn check_bitcoin_address(env: Env, addr: &str) -> bool {
    let addr = match bitcoin::Address::from_str(addr) {
        Ok(a) => a,
        Err(_) => return false,
    };
    match env {
        Env::Prod | Env::Staging | Env::LocalLiquid => addr.network == bitcoin::Network::Bitcoin,
        Env::Local | Env::Regtest | Env::Testnet | Env::LocalTestnet => {
            let script_hash = match addr.payload {
                bitcoin::address::Payload::ScriptHash(_) => true,
                _ => false,
            };
            addr.network == bitcoin::Network::Regtest
                || addr.network == bitcoin::Network::Testnet && script_hash
        }
    }
}

fn elements_params(env: sideswap_common::env::Env) -> &'static elements::AddressParams {
    match env {
        Env::Prod | Env::Staging | Env::LocalLiquid => &elements::address::AddressParams::LIQUID,
        Env::Testnet | Env::LocalTestnet => &gdk_common::network::LIQUID_TESTNET,
        Env::Regtest | Env::Local => &elements::address::AddressParams::ELEMENTS,
    }
}

fn check_elements_address(env: Env, addr: &str) -> bool {
    elements::Address::parse_with_params(addr, elements_params(env))
        .ok()
        .map(|addr| addr.is_blinded())
        .unwrap_or(false)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_address_check() {
        // P2TR
        assert!(check_bitcoin_address(
            Env::Prod,
            "bc1p5cyxnuxmeuwuvkwfem96lqzszd02n6xdcjrs20cac6yqjjwudpxqkedrcr"
        ));
    }
}
