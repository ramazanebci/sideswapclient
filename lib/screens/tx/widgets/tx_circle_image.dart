import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/screens/balances.dart';

enum TxCircleImageType {
  pegIn,
  pegOut,
  swap,
  sent,
  received,
  sentAvatar,
  receivedAvatar,
  unknown
}

TxCircleImageType txTypeToImageType({required TxType type}) {
  TxCircleImageType txCircleImageType;

  switch (type) {
    case TxType.received:
      txCircleImageType = TxCircleImageType.received;
      break;
    case TxType.sent:
      txCircleImageType = TxCircleImageType.sent;
      break;
    case TxType.swap:
      txCircleImageType = TxCircleImageType.swap;
      break;
    case TxType.internal:
      txCircleImageType = TxCircleImageType.swap;
      break;
    case TxType.unknown:
      txCircleImageType = TxCircleImageType.unknown;
      break;
  }

  return txCircleImageType;
}

class TxCircleImage extends StatefulWidget {
  const TxCircleImage({
    super.key,
    required this.txCircleImageType,
    this.width,
    this.height,
    this.fake = false,
  });

  final TxCircleImageType txCircleImageType;
  final double? width;
  final double? height;
  final bool fake;

  @override
  TxCircleImageState createState() => TxCircleImageState();
}

class TxCircleImageState extends State<TxCircleImage> {
  double _width = 0;
  double _height = 0;
  double _largeWidth = 0;
  double _smallWidth = 0;
  double _swapWidth = 0;
  final Color _fakeFrameColor = SideSwapColors.brightTurquoise;
  final Color _fakeIconColor = const Color(0xFFFF996E);

  @override
  void initState() {
    super.initState();

    _width = widget.width ?? 44;
    _height = widget.height ?? _width;
    _largeWidth = (_width * 49.10) / 100;
    _smallWidth = (_width * 45.45) / 100;
    _swapWidth = (_width * 36.66) / 100;
  }

  @override
  Widget build(BuildContext context) {
    late Widget image;
    Color frameColor;
    switch (widget.txCircleImageType) {
      case TxCircleImageType.pegIn:
        frameColor = const Color(0xFFB3FF85);
        image = SvgPicture.asset(
          'assets/tx_peg_in.svg',
          width: _largeWidth,
          colorFilter: ColorFilter.mode(
              widget.fake ? _fakeIconColor : frameColor, BlendMode.srcIn),
        );
        break;
      case TxCircleImageType.pegOut:
        frameColor = SideSwapColors.bitterSweet;
        image = Transform(
          transform: Matrix4.rotationX(-2 * pi / 2),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/tx_peg_in.svg',
            width: _largeWidth,
            colorFilter: ColorFilter.mode(
                widget.fake ? _fakeIconColor : frameColor, BlendMode.srcIn),
          ),
        );
        break;
      case TxCircleImageType.swap:
        frameColor = const Color(0xFFFFE24B);
        image = SvgPicture.asset(
          'assets/tx_swap.svg',
          width: _swapWidth,
          colorFilter: ColorFilter.mode(
              widget.fake ? _fakeIconColor : frameColor, BlendMode.srcIn),
        );
        break;
      case TxCircleImageType.sent:
        frameColor = SideSwapColors.bitterSweet;
        image = SvgPicture.asset(
          'assets/top_right_arrow.svg',
          width: _smallWidth,
          colorFilter: ColorFilter.mode(
              widget.fake ? _fakeIconColor : frameColor, BlendMode.srcIn),
        );
        break;
      case TxCircleImageType.received:
        frameColor = const Color(0xFFB3FF85);
        image = SvgPicture.asset(
          'assets/bottom_left_arrow.svg',
          width: _smallWidth,
          colorFilter: ColorFilter.mode(
              widget.fake ? _fakeIconColor : frameColor, BlendMode.srcIn),
        );
        break;
      case TxCircleImageType.sentAvatar:
        frameColor = SideSwapColors.bitterSweet;
        break;
      case TxCircleImageType.receivedAvatar:
        frameColor = const Color(0xFFB3FF85);
        break;
      case TxCircleImageType.unknown:
        frameColor = Colors.redAccent;
        image = CircleAvatar(
          backgroundColor: frameColor,
        );
        break;
    }
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.fake ? _fakeFrameColor : frameColor,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: image,
      ),
    );
  }
}
