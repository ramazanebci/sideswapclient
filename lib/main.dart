import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/notifications_service.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/background/preload_background_painter.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';
import 'package:sideswap/screens/onboarding/first_launch.dart';
import 'package:sideswap/screens/onboarding/import_wallet_biometric_prompt.dart';
import 'package:sideswap/screens/onboarding/import_wallet_error.dart';
import 'package:sideswap/screens/onboarding/import_wallet_success.dart';
import 'package:sideswap/screens/onboarding/wallet_backup.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_check.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_check_failed.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_check_succeed.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_new_prompt.dart';
import 'package:sideswap/screens/onboarding/wallet_import.dart';
import 'package:sideswap/screens/onboarding/widgets/new_wallet_biometric_prompt.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/payment_page.dart';
import 'package:sideswap/screens/pay/payment_send_popup.dart';
import 'package:sideswap/screens/settings/settings.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/settings_view_backup.dart';
import 'package:sideswap/screens/swap/peg_in_address.dart';
import 'package:sideswap/screens/tx/tx_details_popup.dart';
import 'package:sideswap/screens/wallet_main/wallet_main.dart';
import 'package:sideswap/screens/onboarding/license.dart';
import 'package:sideswap/screens/register.dart';

final initProvider = FutureProvider<void>((ref) async {
  final config = ref.watch(configProvider);
  await config.init();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    CustomPaint(
      painter: PreloadBackgroundPainter(),
      child: EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        //preloaderColor: Colors.transparent,
        child: ProviderScope(child: MyApp()),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    notificationService.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SideSwap',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: _RootWidget(),
    );
  }
}

class MyPopupPage<T> extends Page<T> {
  MyPopupPage({this.child});
  final Widget child;
  @override
  Route<T> createRoute(BuildContext context) {
    return _MyPopupPageRoute<T>(page: this);
  }
}

class _MyPopupPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  _MyPopupPageRoute({
    @required MyPopupPage<T> page,
  })  : assert(page != null),
        super(settings: page);

  MyPopupPage<T> get _page => settings as MyPopupPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => false;
}

class _RootWidget extends StatefulWidget {
  @override
  __RootWidgetState createState() => __RootWidgetState();
}

class __RootWidgetState extends State<_RootWidget> {
  List<Page<dynamic>> pages(Status status) {
    switch (status) {
      case Status.loading:
        return [
          MaterialPage<Widget>(child: PreLaunchPage()),
        ];
      case Status.reviewLicense:
        return [
          MaterialPage<Widget>(child: FirstLaunch()),
          MyPopupPage<Widget>(child: LicenseTerms()),
        ];
      case Status.noWallet:
        return [
          MaterialPage<Widget>(child: FirstLaunch()),
        ];
      case Status.selectEnv:
        return [
          MaterialPage<Widget>(child: FirstLaunch()),
          MyPopupPage<Widget>(child: SelectEnv()),
        ];
      case Status.lockedWalet:
        return [
          MaterialPage<Widget>(child: WalletLocked()),
        ];
      case Status.importWallet:
        return [
          MaterialPage<Widget>(child: FirstLaunch()),
          MaterialPage<Widget>(child: WalletImport()),
        ];
      case Status.importWalletBiometricPrompt:
        return [
          MaterialPage<Widget>(child: ImportWalletBiometricPrompt()),
        ];
      case Status.importWalletSuccess:
        return [
          MaterialPage<Widget>(child: WalletImport()),
          MyPopupPage<Widget>(child: ImportWalletSuccess()),
        ];
      case Status.importWalletError:
        return [
          MaterialPage<Widget>(child: WalletImport()),
          MyPopupPage<Widget>(child: ImportWalletError()),
        ];
      case Status.newWalletBackupPrompt:
        return [
          MaterialPage<Widget>(child: NewWalletBiometricPrompt()),
          MaterialPage<Widget>(child: WalletBackupNewPrompt()),
        ];
      case Status.newWalletBackupView:
        return [
          MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          MyPopupPage<Widget>(child: WalletBackup()),
        ];
      case Status.newWalletBackupCheck:
        return [
          MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          MyPopupPage<Widget>(child: WalletBackup()),
          MyPopupPage<Widget>(child: WalletBackupCheck()),
        ];
      case Status.newWalletBackupCheckFailed:
        return [
          MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          MyPopupPage<Widget>(child: WalletBackupCheckFailed()),
        ];
      case Status.newWalletBackupCheckSucceed:
        return [
          MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          MyPopupPage<Widget>(child: WalletBackupCheckSucceed()),
        ];
      case Status.newWalletBiometricPrompt:
        return [
          MaterialPage<Widget>(child: NewWalletBiometricPrompt()),
        ];

      // WalletMain has it's own navigation system because of
      // MainBottomNavigationBar
      // Use uiStateArgsProvider for changing page
      case Status.registered:
      case Status.assetsSelect:
      case Status.assetDetails:
      case Status.assetReceive:
      case Status.assetReceiveFromWalletMain:
        return [
          MaterialPage<Widget>(child: WalletMain()),
        ];
      case Status.txDetails:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MyPopupPage<Widget>(child: TxDetailsPopup()),
        ];
      case Status.txEditMemo:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: AssetDetails()),
          MyPopupPage<Widget>(child: TxDetailsPopup()),
          MaterialPage<Widget>(child: WalletTxMemo()),
        ];

      case Status.swapWaitPegTx:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: PegInAddress()),
        ];
      case Status.swapTxDetails:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MyPopupPage<Widget>(child: TxDetailsPopup()),
        ];
        break;
      case Status.settingsPage:
        return [
          MaterialPage<Widget>(child: Settings()),
        ];
      case Status.settingsBackup:
        return [
          MaterialPage<Widget>(child: Settings()),
          MaterialPage<Widget>(child: SettingsViewBackup()),
        ];
      case Status.settingsAboutUs:
        return [
          MaterialPage<Widget>(child: Settings()),
          MaterialPage<Widget>(child: SettingsAboutUs()),
        ];
      case Status.settingsSecurity:
        return [
          MaterialPage<Widget>(child: Settings()),
          MaterialPage<Widget>(child: SettingsSecurity()),
        ];
      case Status.paymentPage:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: PaymentPage()),
        ];
      case Status.paymentAmountPage:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: PaymentPage()),
          MaterialPage<Widget>(child: PaymentAmountPage()),
        ];
      case Status.paymentSend:
        return [
          MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: PaymentPage()),
          MaterialPage<Widget>(child: PaymentAmountPage()),
          MyPopupPage<Widget>(child: PaymentSendPopup()),
        ];

        break;
    }
    throw UnimplementedError('unexpecteded state');
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    context.read(walletProvider).navigatorKey = _navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(375, 667), allowFontScaling: true);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: SafeArea(
        child: Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                // https://github.com/flutter/flutter/issues/66349
                return !await context
                    .read(walletProvider)
                    .navigatorKey
                    .currentState
                    .maybePop();
              },
              child: Consumer(
                builder: (context, watch, child) {
                  final status = watch(walletProvider).status;
                  return Navigator(
                    key: _navigatorKey,
                    pages: pages(status),
                    onPopPage: (route, dynamic result) {
                      logger.d('on pop page');
                      if (!route.didPop(result)) {
                        return false;
                      }
                      return true;
                    },
                  );
                },
              ),
            ),
            Consumer(
              builder: (context, watch, child) {
                final initialized = watch(initProvider);
                return initialized.when(
                  data: (value) {
                    final env = watch(configProvider).env;
                    return Visibility(
                      visible: env != 0,
                      child: Align(
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            envName(env),
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        alignment: Alignment.topCenter,
                      ),
                    );
                  },
                  loading: () {
                    return Container();
                  },
                  error: (error, stackTrace) {
                    logger.e('$error $stackTrace');
                    return Container();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
