import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/desktop/onboarding/d_first_launch.dart';
import 'package:sideswap/desktop/onboarding/d_import_wallet_error.dart';
import 'package:sideswap/desktop/onboarding/d_license.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_failed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_succeed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_skip_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup.dart';
import 'package:sideswap/desktop/onboarding/d_pin_setup.dart';
import 'package:sideswap/desktop/onboarding/d_wallet_import.dart';
import 'package:sideswap/desktop/pageRoute/desktop_page_route.dart';
import 'package:sideswap/desktop/settings/d_settings.dart';
import 'package:sideswap/desktop/settings/d_settings_about_us.dart';
import 'package:sideswap/desktop/settings/d_settings_network_access.dart';
import 'package:sideswap/desktop/settings/d_settings_pin_success.dart';
import 'package:sideswap/desktop/settings/d_settings_view_backup.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/screens/onboarding/license.dart';
import 'package:sideswap/screens/onboarding/widgets/new_wallet_pin_welcome.dart';

import 'desktop_wallet_main.dart';

class RouteName {
  static const String first = '/';
  static const String noWallet = '/noWallet';
  static const String reviewLicenseCreateWallet = '/reviewLicenseCreateWallet';
  static const String reviewLicenseImportWallet = '/reviewLicenseImportWallet';
  static const String importWallet = '/importWallet';
  static const String importWalletError = '/importWalletError';
  static const String newWalletBackupPrompt = '/newWalletBackupPrompt';
  static const String newWalletBackupSkipPrompt = '/newWalletBackupSkipPrompt';
  static const String newWalletBackupView = '/newWalletBackupView';
  static const String newWalletBackupCheck = '/newWalletBackupCheck';
  static const String newWalletBackupCheckFailed =
      '/newWalletBackupCheckFailed';
  static const String newWalletBackupCheckSucceed =
      '/newWalletBackupCheckSucceed';
  static const String newWalletPinWelcome = '/newWalletPinWelcome';
  static const String pinSetup = '/pinSetup';
  static const String registered = '/registered';
  static const String errorRoute = '/errorRoute';
  static const String settingsPage = '/settingsPage';
  static const String settingsBackup = '/settingsBackup';
  static const String settingsAboutUs = '/settingsAboutUs';
  static const String pinSuccess = '/pinSuccess';
  static const String settingsNetwork = '/settingsNetwork';
}

class RouteGenerator {
  static Route<Widget> generateRoute(RouteSettings settings) {
    final container = ProviderContainer();

    switch (settings.name) {
      case RouteName.first:
        return DesktopPageRoute<Widget>(
            builder: (_) => const PreLaunchPage(), settings: settings);
      case RouteName.noWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DFirstLaunch(), settings: settings);
      case RouteName.reviewLicenseCreateWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DLicense(
                  nextStep: LicenseNextStep.createWallet,
                ),
            settings: settings);
      case RouteName.reviewLicenseImportWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DLicense(
                  nextStep: LicenseNextStep.importWallet,
                ),
            settings: settings);
      case RouteName.importWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DWalletImport(), settings: settings);
      case RouteName.importWalletError:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DImportWalletError(), settings: settings);
      case RouteName.newWalletBackupPrompt:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupPrompt(), settings: settings);
      case RouteName.newWalletBackupSkipPrompt:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupSkipPrompt(),
            settings: settings);
      case RouteName.newWalletBackupView:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackup(), settings: settings);
      case RouteName.newWalletBackupCheck:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupCheck(), settings: settings);
      case RouteName.newWalletBackupCheckFailed:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupCheckFailed(),
            settings: settings);
      case RouteName.newWalletBackupCheckSucceed:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupCheckSucceed(),
            settings: settings);
      case RouteName.newWalletPinWelcome:
        return DesktopPageRoute(
            builder: (_) => const NewWalletPinWelcome(), settings: settings);
      case RouteName.pinSetup:
        if (container.read(pinSetupProvider).isNewWallet) {
          return DesktopPageRoute(
              builder: (_) => const DPinSetup(), settings: settings);
        } else {
          return RawDialogRoute<Widget>(
              pageBuilder: (_, __, ___) => const DPinSetup(),
              settings: settings);
        }
      case RouteName.registered:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DesktopWalletMain(), settings: settings);
      case RouteName.settingsPage:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettings(), settings: settings);
      case RouteName.settingsBackup:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsViewBackup(),
            settings: settings);
      case RouteName.settingsAboutUs:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsAboutUs(),
            settings: settings);
      case RouteName.pinSuccess:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsPinSuccess(),
            settings: settings);
      case RouteName.settingsNetwork:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsNetworkAccess(),
            settings: settings);

      default:
        return errorRoute(settings);
    }
  }

  static Route<Widget> errorRoute(RouteSettings settings) {
    logger.e('Unhandled page status ${settings.name}');
    return DesktopPageRoute<Widget>(
        builder: (_) {
          return const SideSwapScaffoldPage(
            content: Center(
              child: Text('ERROR'),
            ),
          );
        },
        settings: settings);
  }
}

class RouteContainer extends ConsumerStatefulWidget {
  const RouteContainer({Key? key}) : super(key: key);

  @override
  ConsumerState<RouteContainer> createState() => _RouteContainerState();
}

class _RouteContainerState extends ConsumerState<RouteContainer> {
  Future<void> onStatus(Status status) async {
    final context = ref.read(walletProvider).navigatorKey.currentContext!;

    var routeName = RouteName.errorRoute;
    switch (status) {
      case Status.loading:
      case Status.walletLoading:
        routeName = RouteName.first;
        break;
      case Status.noWallet:
      case Status.selectEnv:
        routeName = RouteName.noWallet;
        break;
      case Status.reviewLicenseCreateWallet:
        routeName = RouteName.reviewLicenseCreateWallet;
        break;
      case Status.reviewLicenseImportWallet:
        routeName = RouteName.reviewLicenseImportWallet;
        break;
      case Status.importWallet:
        routeName = RouteName.importWallet;
        break;
      case Status.importWalletError:
        routeName = RouteName.importWalletError;
        break;
      case Status.importWalletSuccess:
        // TODO: temporary, to handle login wallet after importing
        ref.read(walletProvider).setImportWalletBiometricPrompt();
        routeName = RouteName.registered;
        break;
      case Status.newWalletPinWelcome:
        routeName = RouteName.newWalletPinWelcome;
        break;
      case Status.pinWelcome:
      case Status.pinSetup:
        routeName = RouteName.pinSetup;

        if (!ref.read(pinSetupProvider).isNewWallet) {
          Navigator.pushNamedAndRemoveUntil(
              context, routeName, (route) => route.isFirst);
          return;
        }
        break;
      case Status.pinSuccess:
        if (ref.read(pinSetupProvider).isNewWallet) {
          await ref.read(walletProvider).walletBiometricSkip();
          ref.read(walletProvider).newWalletBackupPrompt();
          return;
        }

        routeName = RouteName.pinSuccess;
        Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => route.isFirst);
        return;
      case Status.importAvatar:
      case Status.importAvatarSuccess:
      case Status.associatePhoneWelcome:
      case Status.confirmPhone:
      case Status.confirmPhoneSuccess:
      case Status.importContacts:
      case Status.importContactsSuccess:
        await ref.read(walletProvider).newWalletBiometricPrompt();
        return;
      case Status.newWalletBackupPrompt:
        routeName = RouteName.newWalletBackupPrompt;
        break;
      case Status.newWalletBackupView:
        routeName = RouteName.newWalletBackupView;
        break;
      case Status.newWalletBackupCheck:
        routeName = RouteName.newWalletBackupCheck;
        break;
      case Status.newWalletBackupCheckFailed:
        routeName = RouteName.newWalletBackupCheckFailed;
        break;
      case Status.newWalletBackupCheckSucceed:
        routeName = RouteName.newWalletBackupCheckSucceed;
        break;
      case Status.registered:
        routeName = RouteName.registered;

        if (Navigator.canPop(context)) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          Navigator.pushReplacementNamed(context, routeName);
        }

        return;
      case Status.settingsPage:
        routeName = RouteName.settingsPage;
        Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => route.isFirst);
        return;
      case Status.settingsBackup:
        routeName = RouteName.settingsBackup;
        Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => route.isFirst);
        return;
      case Status.settingsAboutUs:
        routeName = RouteName.settingsAboutUs;
        Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => route.isFirst);
        return;
      case Status.settingsNetwork:
        routeName = RouteName.settingsNetwork;
        Navigator.pushNamedAndRemoveUntil(
            context, routeName, (route) => route.isFirst);
        return;

      case Status.lockedWalet:
      case Status.newWalletBiometricPrompt:
      case Status.importWalletBiometricPrompt:
      case Status.assetsSelect:
      case Status.assetDetails:
      case Status.txDetails:
      case Status.txEditMemo:
      case Status.assetReceive:
      case Status.assetReceiveFromWalletMain:
      case Status.swapWaitPegTx:
      case Status.swapTxDetails:
      case Status.settingsSecurity:
      case Status.settingsUserDetails:
      case Status.paymentPage:
      case Status.paymentAmountPage:
      case Status.paymentSend:
      case Status.orderPopup:
      case Status.orderSuccess:
      case Status.orderResponseSuccess:
      case Status.swapPrompt:
      case Status.createOrderEntry:
      case Status.createOrder:
      case Status.createOrderSuccess:
      case Status.orderRequestView:
        // Not used on desktop
        break;
    }

    await Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Status>(walletProvider.select((p) => p.status), (_, next) async {
      await onStatus(next);
    });
    return Container();
  }
}