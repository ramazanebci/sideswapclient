import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/providers/accounts_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class AccountItem extends StatelessWidget {
  final AccountAsset accountAsset;
  final ValueChanged<AccountAsset> onSelected;
  final bool disabled;

  const AccountItem({
    super.key,
    required this.accountAsset,
    required this.onSelected,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = disabled ? const Color(0xFFAAAAAA) : Colors.white;
    final backgrounColor =
        disabled ? const Color(0xFF034569) : SideSwapColors.chathamsBlue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 80,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgrounColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: disabled
              ? null
              : () {
                  onSelected(accountAsset);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final icon = ref
                          .watch(assetImageProvider)
                          .getBigImage(accountAsset.assetId);
                      return icon;
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 48,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      final asset = ref.watch(
                                          assetsStateProvider.select((value) =>
                                              value[accountAsset.assetId]));

                                      return Text(
                                        asset?.name ?? '',
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal,
                                          color: textColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                AccountItemAmount(
                                  accountAsset: accountAsset,
                                  disabled: disabled,
                                ),
                              ],
                            ),
                          ),
                          AccountItemConversion(accountAsset: accountAsset),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountItemConversion extends StatelessWidget {
  const AccountItemConversion({
    super.key,
    required this.accountAsset,
  });

  final AccountAsset accountAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final asset = ref.watch(assetsStateProvider
                    .select((value) => value[accountAsset.assetId]));

                return Text(
                  asset?.ticker ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B91A8),
                  ),
                );
              },
            ),
            if (accountAsset.account.isAmp)
              const AmpFlag(
                textStyle: TextStyle(
                  color: Color(0xFF73A6C5),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        Consumer(
          builder: (context, ref, child) {
            final result =
                ref.watch(accountItemDollarConversionProvider(accountAsset));

            return switch (result.amountUsd) {
              0 => const SizedBox(),
              _ => Text(
                  '≈ ${result.dollarConversion}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B91A8),
                  ),
                ),
            };
          },
        ),
      ],
    );
  }
}

class AccountItemAmount extends ConsumerWidget {
  const AccountItemAmount({
    super.key,
    required this.accountAsset,
    this.disabled = false,
  });

  final AccountAsset accountAsset;
  final bool disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountString = ref.watch(accountItemAmountProvider(accountAsset));
    final textColor = disabled ? const Color(0xFFAAAAAA) : Colors.white;

    return switch (amountString) {
      final amountString? => Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            amountString,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      _ => const SizedBox(),
    };
  }
}
