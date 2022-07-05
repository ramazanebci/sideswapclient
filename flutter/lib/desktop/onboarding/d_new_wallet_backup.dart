import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo_background.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/models/mnemonic_table_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DNewWalletBackup extends ConsumerStatefulWidget {
  const DNewWalletBackup({super.key});

  @override
  ConsumerState<DNewWalletBackup> createState() => _DWalletBackupState();
}

class _DWalletBackupState extends ConsumerState<DNewWalletBackup> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final words = ref.read(walletProvider).getMnemonicWords();
      final wordItems = Map<int, WordItem>.fromEntries(List.generate(
          words.length,
          (index) => MapEntry(index, WordItem(words[index], true))));
      ref.read(mnemonicWordItemsProvider.notifier).state = wordItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).newWalletBackupPrompt();
      },
      backgroundContent: const DNewWalletBackupLogoBackground(),
      constraints: const BoxConstraints(maxWidth: 628),
      content: Center(
        child: SizedBox(
          width: 484,
          child: Column(
            children: [
              Text(
                'Save your 12 word recovery phrase'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Please ensure you write down and save your 12 word recovery phrase. Without your recovery phrase, there is no way to restore access to your wallet and all balances will be irretrievably lost without recourse.'
                      .tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: DMnemonicTable(
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: DCustomFilledBigButton(
            width: 460,
            height: 49,
            onPressed: () {
              ref.read(walletProvider).backupNewWalletCheck();
            },
            child: Text(
              'CONFIRM YOUR WORDS'.tr(),
            ),
          ),
        ),
      ],
    );
  }
}