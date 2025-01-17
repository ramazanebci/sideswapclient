import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/d_pin_welcome.dart';

import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/pin_welcome.dart';

class NewWalletPinWelcome extends ConsumerWidget {
  const NewWalletPinWelcome({super.key});

  void onYesPressedCallback(WidgetRef ref) {
    ref.read(pinSetupProvider).initPinSetupNewWalletPinWelcome();
  }

  Future<void> onNoPressedCallback(WidgetRef ref) async {
    // important - clear new wallet state in pin provider!
    ref.read(pinSetupProvider).isNewWallet = false;

    final wallet = ref.read(walletProvider);
    if (wallet.walletImporting) {
      await wallet.setImportWalletBiometricPrompt();
    } else {
      await wallet.newWalletBiometricPrompt();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlavorConfig.isDesktop
        ? DPinWelcome(
            onYesPressed: () {
              onYesPressedCallback(ref);
            },
            onNoPressed: () async {
              await onNoPressedCallback(ref);
            },
          )
        : PinWelcome(
            onYesPressed: () {
              onYesPressedCallback(ref);
            },
            onNoPressed: () async {
              await onNoPressedCallback(ref);
            },
          );
  }
}
