// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// SideSwap FFI
class NativeLibrary {
  /// Holds the Dynamic library.
  final ffi.DynamicLibrary _dylib;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary) : _dylib = dynamicLibrary;

  int sideswap_client_create(
    int env,
  ) {
    _sideswap_client_create ??= _dylib.lookupFunction<_c_sideswap_client_create,
        _dart_sideswap_client_create>('sideswap_client_create');
    return _sideswap_client_create(
      env,
    );
  }

  _dart_sideswap_client_create _sideswap_client_create;

  void sideswap_client_start(
    int client,
    ffi.Pointer<ffi.Int8> work_dir,
    ffi.Pointer<ffi.Int8> version,
    int dart_port,
  ) {
    _sideswap_client_start ??= _dylib.lookupFunction<_c_sideswap_client_start,
        _dart_sideswap_client_start>('sideswap_client_start');
    return _sideswap_client_start(
      client,
      work_dir,
      version,
      dart_port,
    );
  }

  _dart_sideswap_client_start _sideswap_client_start;

  void sideswap_send_request(
    int client,
    ffi.Pointer<ffi.Uint8> data,
    int len,
  ) {
    _sideswap_send_request ??= _dylib.lookupFunction<_c_sideswap_send_request,
        _dart_sideswap_send_request>('sideswap_send_request');
    return _sideswap_send_request(
      client,
      data,
      len,
    );
  }

  _dart_sideswap_send_request _sideswap_send_request;

  bool sideswap_check_addr(
    int client,
    ffi.Pointer<ffi.Int8> addr,
    int addr_type,
  ) {
    _sideswap_check_addr ??= _dylib.lookupFunction<_c_sideswap_check_addr,
        _dart_sideswap_check_addr>('sideswap_check_addr');
    return _sideswap_check_addr(
          client,
          addr,
          addr_type,
        ) !=
        0;
  }

  _dart_sideswap_check_addr _sideswap_check_addr;

  int sideswap_parse_bitcoin_amount(
    ffi.Pointer<ffi.Int8> amount,
  ) {
    _sideswap_parse_bitcoin_amount ??= _dylib.lookupFunction<
        _c_sideswap_parse_bitcoin_amount,
        _dart_sideswap_parse_bitcoin_amount>('sideswap_parse_bitcoin_amount');
    return _sideswap_parse_bitcoin_amount(
      amount,
    );
  }

  _dart_sideswap_parse_bitcoin_amount _sideswap_parse_bitcoin_amount;

  bool sideswap_parsed_amount_valid(
    int amount,
  ) {
    _sideswap_parsed_amount_valid ??= _dylib.lookupFunction<
        _c_sideswap_parsed_amount_valid,
        _dart_sideswap_parsed_amount_valid>('sideswap_parsed_amount_valid');
    return _sideswap_parsed_amount_valid(
          amount,
        ) !=
        0;
  }

  _dart_sideswap_parsed_amount_valid _sideswap_parsed_amount_valid;

  ffi.Pointer<ffi.Uint8> sideswap_msg_ptr(
    int msg,
  ) {
    _sideswap_msg_ptr ??=
        _dylib.lookupFunction<_c_sideswap_msg_ptr, _dart_sideswap_msg_ptr>(
            'sideswap_msg_ptr');
    return _sideswap_msg_ptr(
      msg,
    );
  }

  _dart_sideswap_msg_ptr _sideswap_msg_ptr;

  int sideswap_msg_len(
    int msg,
  ) {
    _sideswap_msg_len ??=
        _dylib.lookupFunction<_c_sideswap_msg_len, _dart_sideswap_msg_len>(
            'sideswap_msg_len');
    return _sideswap_msg_len(
      msg,
    );
  }

  _dart_sideswap_msg_len _sideswap_msg_len;

  void sideswap_msg_free(
    int msg,
  ) {
    _sideswap_msg_free ??=
        _dylib.lookupFunction<_c_sideswap_msg_free, _dart_sideswap_msg_free>(
            'sideswap_msg_free');
    return _sideswap_msg_free(
      msg,
    );
  }

  _dart_sideswap_msg_free _sideswap_msg_free;

  ffi.Pointer<ffi.Int8> sideswap_generate_mnemonic12() {
    _sideswap_generate_mnemonic12 ??= _dylib.lookupFunction<
        _c_sideswap_generate_mnemonic12,
        _dart_sideswap_generate_mnemonic12>('sideswap_generate_mnemonic12');
    return _sideswap_generate_mnemonic12();
  }

  _dart_sideswap_generate_mnemonic12 _sideswap_generate_mnemonic12;

  bool sideswap_verify_mnemonic(
    ffi.Pointer<ffi.Int8> mnemonic,
  ) {
    _sideswap_verify_mnemonic ??= _dylib.lookupFunction<
        _c_sideswap_verify_mnemonic,
        _dart_sideswap_verify_mnemonic>('sideswap_verify_mnemonic');
    return _sideswap_verify_mnemonic(
          mnemonic,
        ) !=
        0;
  }

  _dart_sideswap_verify_mnemonic _sideswap_verify_mnemonic;

  void sideswap_string_free(
    ffi.Pointer<ffi.Int8> str,
  ) {
    _sideswap_string_free ??= _dylib.lookupFunction<_c_sideswap_string_free,
        _dart_sideswap_string_free>('sideswap_string_free');
    return _sideswap_string_free(
      str,
    );
  }

  _dart_sideswap_string_free _sideswap_string_free;
}

class __fsid_t extends ffi.Struct {}

abstract class idtype_t {
  static const int P_ALL = 0;
  static const int P_PID = 1;
  static const int P_PGID = 2;
}

class div_t extends ffi.Struct {
  @ffi.Int32()
  int quot;

  @ffi.Int32()
  int rem;
}

class ldiv_t extends ffi.Struct {
  @ffi.Int64()
  int quot;

  @ffi.Int64()
  int rem;
}

class lldiv_t extends ffi.Struct {
  @ffi.Int64()
  int quot;

  @ffi.Int64()
  int rem;
}

class __sigset_t extends ffi.Struct {}

class timeval extends ffi.Struct {
  @ffi.Int64()
  int tv_sec;

  @ffi.Int64()
  int tv_usec;
}

class timespec extends ffi.Struct {
  @ffi.Int64()
  int tv_sec;

  @ffi.Int64()
  int tv_nsec;
}

class fd_set extends ffi.Struct {}

class __pthread_rwlock_arch_t extends ffi.Struct {}

class __pthread_list_t extends ffi.Struct {
  ffi.Pointer<__pthread_list_t> __prev;

  ffi.Pointer<__pthread_list_t> __next;
}

class __pthread_mutex_s extends ffi.Struct {}

class __pthread_cond_s extends ffi.Struct {}

class random_data extends ffi.Struct {
  ffi.Pointer<ffi.Int32> fptr;

  ffi.Pointer<ffi.Int32> rptr;

  ffi.Pointer<ffi.Int32> state;

  @ffi.Int32()
  int rand_type;

  @ffi.Int32()
  int rand_deg;

  @ffi.Int32()
  int rand_sep;

  ffi.Pointer<ffi.Int32> end_ptr;
}

class drand48_data extends ffi.Struct {}

const int __GNUC_VA_LIST = 1;

const int true_1 = 1;

const int false_1 = 0;

const int __bool_true_false_are_defined = 1;

const int _STDINT_H = 1;

const int _FEATURES_H = 1;

const int _DEFAULT_SOURCE = 1;

const int __USE_ISOC11 = 1;

const int __USE_ISOC99 = 1;

const int __USE_ISOC95 = 1;

const int _POSIX_SOURCE = 1;

const int _POSIX_C_SOURCE = 200809;

const int __USE_POSIX = 1;

const int __USE_POSIX2 = 1;

const int __USE_POSIX199309 = 1;

const int __USE_POSIX199506 = 1;

const int __USE_XOPEN2K = 1;

const int __USE_XOPEN2K8 = 1;

const int _ATFILE_SOURCE = 1;

const int __USE_MISC = 1;

const int __USE_ATFILE = 1;

const int __USE_FORTIFY_LEVEL = 0;

const int __GLIBC_USE_DEPRECATED_GETS = 0;

const int _STDC_PREDEF_H = 1;

const int __STDC_IEC_559__ = 1;

const int __STDC_IEC_559_COMPLEX__ = 1;

const int __STDC_ISO_10646__ = 201706;

const int __GNU_LIBRARY__ = 6;

const int __GLIBC__ = 2;

const int __GLIBC_MINOR__ = 28;

const int _SYS_CDEFS_H = 1;

const int __glibc_c99_flexarr_available = 1;

const int __WORDSIZE = 64;

const int __WORDSIZE_TIME64_COMPAT32 = 1;

const int __SYSCALL_WORDSIZE = 64;

const int __HAVE_GENERIC_SELECTION = 0;

const int __GLIBC_USE_LIB_EXT2 = 1;

const int __GLIBC_USE_IEC_60559_BFP_EXT = 1;

const int __GLIBC_USE_IEC_60559_FUNCS_EXT = 1;

const int __GLIBC_USE_IEC_60559_TYPES_EXT = 1;

const int _BITS_TYPES_H = 1;

const int _BITS_TYPESIZES_H = 1;

const int __OFF_T_MATCHES_OFF64_T = 1;

const int __INO_T_MATCHES_INO64_T = 1;

const int __RLIM_T_MATCHES_RLIM64_T = 1;

const int __FD_SETSIZE = 1024;

const int _BITS_WCHAR_H = 1;

const int __WCHAR_MAX = 2147483647;

const int __WCHAR_MIN = -2147483648;

const int _BITS_STDINT_INTN_H = 1;

const int _BITS_STDINT_UINTN_H = 1;

const int INT8_MIN = -128;

const int INT16_MIN = -32768;

const int INT32_MIN = -2147483648;

const int INT64_MIN = -9223372036854775808;

const int INT8_MAX = 127;

const int INT16_MAX = 32767;

const int INT32_MAX = 2147483647;

const int INT64_MAX = 9223372036854775807;

const int UINT8_MAX = 255;

const int UINT16_MAX = 65535;

const int UINT32_MAX = 4294967295;

const int UINT64_MAX = -1;

const int INT_LEAST8_MIN = -128;

const int INT_LEAST16_MIN = -32768;

const int INT_LEAST32_MIN = -2147483648;

const int INT_LEAST64_MIN = -9223372036854775808;

const int INT_LEAST8_MAX = 127;

const int INT_LEAST16_MAX = 32767;

const int INT_LEAST32_MAX = 2147483647;

const int INT_LEAST64_MAX = 9223372036854775807;

const int UINT_LEAST8_MAX = 255;

const int UINT_LEAST16_MAX = 65535;

const int UINT_LEAST32_MAX = 4294967295;

const int UINT_LEAST64_MAX = -1;

const int INT_FAST8_MIN = -128;

const int INT_FAST16_MIN = -9223372036854775808;

const int INT_FAST32_MIN = -9223372036854775808;

const int INT_FAST64_MIN = -9223372036854775808;

const int INT_FAST8_MAX = 127;

const int INT_FAST16_MAX = 9223372036854775807;

const int INT_FAST32_MAX = 9223372036854775807;

const int INT_FAST64_MAX = 9223372036854775807;

const int UINT_FAST8_MAX = 255;

const int UINT_FAST16_MAX = -1;

const int UINT_FAST32_MAX = -1;

const int UINT_FAST64_MAX = -1;

const int INTPTR_MIN = -9223372036854775808;

const int INTPTR_MAX = 9223372036854775807;

const int UINTPTR_MAX = -1;

const int INTMAX_MIN = -9223372036854775808;

const int INTMAX_MAX = 9223372036854775807;

const int UINTMAX_MAX = -1;

const int PTRDIFF_MIN = -9223372036854775808;

const int PTRDIFF_MAX = 9223372036854775807;

const int SIG_ATOMIC_MIN = -2147483648;

const int SIG_ATOMIC_MAX = 2147483647;

const int SIZE_MAX = -1;

const int WCHAR_MIN = -2147483648;

const int WCHAR_MAX = 2147483647;

const int WINT_MIN = 0;

const int WINT_MAX = 4294967295;

const int NULL = 0;

const int _STDLIB_H = 1;

const int WNOHANG = 1;

const int WUNTRACED = 2;

const int WSTOPPED = 2;

const int WEXITED = 4;

const int WCONTINUED = 8;

const int WNOWAIT = 16777216;

const int __WNOTHREAD = 536870912;

const int __WALL = 1073741824;

const int __WCLONE = 2147483648;

const int __ENUM_IDTYPE_T = 1;

const int __W_CONTINUED = 65535;

const int __WCOREFLAG = 128;

const int __HAVE_FLOAT128 = 0;

const int __HAVE_DISTINCT_FLOAT128 = 0;

const int __HAVE_FLOAT64X = 1;

const int __HAVE_FLOAT64X_LONG_DOUBLE = 1;

const int __HAVE_FLOAT16 = 0;

const int __HAVE_FLOAT32 = 1;

const int __HAVE_FLOAT64 = 1;

const int __HAVE_FLOAT32X = 1;

const int __HAVE_FLOAT128X = 0;

const int __HAVE_DISTINCT_FLOAT16 = 0;

const int __HAVE_DISTINCT_FLOAT32 = 0;

const int __HAVE_DISTINCT_FLOAT64 = 0;

const int __HAVE_DISTINCT_FLOAT32X = 0;

const int __HAVE_DISTINCT_FLOAT64X = 0;

const int __HAVE_DISTINCT_FLOAT128X = 0;

const int __HAVE_FLOAT128_UNLIKE_LDBL = 0;

const int __HAVE_FLOATN_NOT_TYPEDEF = 0;

const int __ldiv_t_defined = 1;

const int __lldiv_t_defined = 1;

const int RAND_MAX = 2147483647;

const int EXIT_FAILURE = 1;

const int EXIT_SUCCESS = 0;

const int _SYS_TYPES_H = 1;

const int __clock_t_defined = 1;

const int __clockid_t_defined = 1;

const int __time_t_defined = 1;

const int __timer_t_defined = 1;

const int __BIT_TYPES_DEFINED__ = 1;

const int _ENDIAN_H = 1;

const int __LITTLE_ENDIAN = 1234;

const int __BIG_ENDIAN = 4321;

const int __PDP_ENDIAN = 3412;

const int __BYTE_ORDER = 1234;

const int __FLOAT_WORD_ORDER = 1234;

const int LITTLE_ENDIAN = 1234;

const int BIG_ENDIAN = 4321;

const int PDP_ENDIAN = 3412;

const int BYTE_ORDER = 1234;

const int _BITS_BYTESWAP_H = 1;

const int _BITS_UINTN_IDENTITY_H = 1;

const int _SYS_SELECT_H = 1;

const String __FD_ZERO_STOS = 'stosq';

const int __sigset_t_defined = 1;

const int _SIGSET_NWORDS = 16;

const int __timeval_defined = 1;

const int _STRUCT_TIMESPEC = 1;

const int __NFDBITS = 64;

const int FD_SETSIZE = 1024;

const int NFDBITS = 64;

const int _BITS_PTHREADTYPES_COMMON_H = 1;

const int _THREAD_SHARED_TYPES_H = 1;

const int _BITS_PTHREADTYPES_ARCH_H = 1;

const int __SIZEOF_PTHREAD_MUTEX_T = 40;

const int __SIZEOF_PTHREAD_ATTR_T = 56;

const int __SIZEOF_PTHREAD_RWLOCK_T = 56;

const int __SIZEOF_PTHREAD_BARRIER_T = 32;

const int __SIZEOF_PTHREAD_MUTEXATTR_T = 4;

const int __SIZEOF_PTHREAD_COND_T = 48;

const int __SIZEOF_PTHREAD_CONDATTR_T = 4;

const int __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;

const int __SIZEOF_PTHREAD_BARRIERATTR_T = 4;

const int __PTHREAD_MUTEX_LOCK_ELISION = 1;

const int __PTHREAD_MUTEX_NUSERS_AFTER_KIND = 0;

const int __PTHREAD_MUTEX_USE_UNION = 0;

const int __PTHREAD_RWLOCK_ELISION_EXTRA = 0;

const int __PTHREAD_RWLOCK_INT_FLAGS_SHARED = 1;

const int __PTHREAD_SPINS = 0;

const int __PTHREAD_MUTEX_HAVE_PREV = 1;

const int __have_pthread_attr_t = 1;

const int _ALLOCA_H = 1;

const int SIDESWAP_BITCOIN = 1;

const int SIDESWAP_ELEMENTS = 2;

const int SIDESWAP_ENV_PROD = 0;

const int SIDESWAP_ENV_STAGING = 1;

const int SIDESWAP_ENV_REGTEST = 2;

const int SIDESWAP_ENV_LOCAL = 3;

typedef _c_sideswap_client_create = ffi.Uint64 Function(
  ffi.Int32 env,
);

typedef _dart_sideswap_client_create = int Function(
  int env,
);

typedef _c_sideswap_client_start = ffi.Void Function(
  ffi.Uint64 client,
  ffi.Pointer<ffi.Int8> work_dir,
  ffi.Pointer<ffi.Int8> version,
  ffi.Int64 dart_port,
);

typedef _dart_sideswap_client_start = void Function(
  int client,
  ffi.Pointer<ffi.Int8> work_dir,
  ffi.Pointer<ffi.Int8> version,
  int dart_port,
);

typedef _c_sideswap_send_request = ffi.Void Function(
  ffi.Uint64 client,
  ffi.Pointer<ffi.Uint8> data,
  ffi.Uint64 len,
);

typedef _dart_sideswap_send_request = void Function(
  int client,
  ffi.Pointer<ffi.Uint8> data,
  int len,
);

typedef _c_sideswap_check_addr = ffi.Uint8 Function(
  ffi.Uint64 client,
  ffi.Pointer<ffi.Int8> addr,
  ffi.Int32 addr_type,
);

typedef _dart_sideswap_check_addr = int Function(
  int client,
  ffi.Pointer<ffi.Int8> addr,
  int addr_type,
);

typedef _c_sideswap_parse_bitcoin_amount = ffi.Int64 Function(
  ffi.Pointer<ffi.Int8> amount,
);

typedef _dart_sideswap_parse_bitcoin_amount = int Function(
  ffi.Pointer<ffi.Int8> amount,
);

typedef _c_sideswap_parsed_amount_valid = ffi.Uint8 Function(
  ffi.Int64 amount,
);

typedef _dart_sideswap_parsed_amount_valid = int Function(
  int amount,
);

typedef _c_sideswap_msg_ptr = ffi.Pointer<ffi.Uint8> Function(
  ffi.Uint64 msg,
);

typedef _dart_sideswap_msg_ptr = ffi.Pointer<ffi.Uint8> Function(
  int msg,
);

typedef _c_sideswap_msg_len = ffi.Uint64 Function(
  ffi.Uint64 msg,
);

typedef _dart_sideswap_msg_len = int Function(
  int msg,
);

typedef _c_sideswap_msg_free = ffi.Void Function(
  ffi.Uint64 msg,
);

typedef _dart_sideswap_msg_free = void Function(
  int msg,
);

typedef _c_sideswap_generate_mnemonic12 = ffi.Pointer<ffi.Int8> Function();

typedef _dart_sideswap_generate_mnemonic12 = ffi.Pointer<ffi.Int8> Function();

typedef _c_sideswap_verify_mnemonic = ffi.Uint8 Function(
  ffi.Pointer<ffi.Int8> mnemonic,
);

typedef _dart_sideswap_verify_mnemonic = int Function(
  ffi.Pointer<ffi.Int8> mnemonic,
);

typedef _c_sideswap_string_free = ffi.Void Function(
  ffi.Pointer<ffi.Int8> str,
);

typedef _dart_sideswap_string_free = void Function(
  ffi.Pointer<ffi.Int8> str,
);
