import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class AssetDetailsHeader extends ConsumerWidget {
  AssetDetailsHeader({
    Key key,
    @required this.percent,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var _dollarConversion = '0.0';

    return Opacity(
      opacity: percent,
      child: Column(
        children: [
          Consumer(
            builder: (context, watch, child) {
              final asset = watch(walletProvider).assets[
                  watch(walletProvider).selectedWalletAsset ??
                      kLiquidBitcoinTicker];
              return Text(
                asset.name,
                style: GoogleFonts.roboto(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Consumer(
              builder: (context, watch, child) {
                final balance = watch(walletProvider).balances[
                    watch(walletProvider).selectedWalletAsset ??
                        kLiquidBitcoinTicker];
                final asset = watch(walletProvider).assets[
                    watch(walletProvider).selectedWalletAsset ??
                        kLiquidBitcoinTicker];

                final ticker = asset.ticker ?? kLiquidBitcoinTicker;
                final balanceStr = '${amountStr(balance ?? 0)} $ticker';
                return Text(
                  balanceStr,
                  style: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Consumer(
              builder: (context, watch, child) {
                final asset = watch(walletProvider).assets[
                    watch(walletProvider).selectedWalletAsset ??
                        kLiquidBitcoinTicker];
                final balance = double.tryParse(amountStr(
                        watch(walletProvider).balances[
                                watch(walletProvider).selectedWalletAsset ??
                                    kLiquidBitcoinTicker] ??
                            0)) ??
                    .0;
                final amountUsd =
                    watch(walletProvider).getAmountUsd(asset.ticker, balance);
                _dollarConversion = amountUsd.toStringAsFixed(2);
                _dollarConversion = replaceCharacterOnPosition(
                    input: _dollarConversion, currencyChar: '\$');
                return Text(
                  '≈ $_dollarConversion',
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B91A8),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButtonWithLabel(
                  onTap: () {
                    context.read(walletProvider).selectAssetReceive();
                  },
                  label: 'Receive'.tr(),
                  child: SvgPicture.asset(
                    'assets/bottom_left_arrow.svg',
                    width: 28.w,
                    height: 28.w,
                  ),
                  buttonBackground: Colors.white,
                ),
                Container(
                  width: 32.w,
                ),
                RoundedButtonWithLabel(
                  onTap: () {
                    context.read(walletProvider).selectPaymentPage();
                  },
                  label: 'Send'.tr(),
                  child: SvgPicture.asset(
                    'assets/top_right_arrow.svg',
                    width: 28.w,
                    height: 28.w,
                  ),
                  buttonBackground: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
