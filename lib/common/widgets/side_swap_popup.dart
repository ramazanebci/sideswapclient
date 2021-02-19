import 'package:flutter/material.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/screen_utils.dart';

class SideSwapPopup extends StatelessWidget {
  SideSwapPopup({
    Key key,
    this.child,
    this.appBar,
    Color backgroundColor,
    this.useDefaultTopPadding = true,
    this.useDefaultHorizontalPadding = true,
    this.onClose,
    this.onWillPop,
    this.hideCloseButton = false,
  })  : _backgroundColor = backgroundColor ?? Color(0xFF135579),
        super(key: key);

  final Widget child;
  final AppBar appBar;
  final Color _backgroundColor;
  final bool useDefaultTopPadding;
  final bool useDefaultHorizontalPadding;
  final VoidCallback onClose;
  final WillPopCallback onWillPop;
  final bool hideCloseButton;

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: onWillPop,
      appBar: appBar,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.w),
                        topRight: Radius.circular(16.w),
                      ),
                      color: _backgroundColor,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  useDefaultHorizontalPadding ? 16.w : 0.w),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: useDefaultTopPadding ? 28.h : 0.h),
                            child: child,
                          ),
                        ),
                        if (!hideCloseButton) ...[
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 25.h, right: 22.w),
                              child: CustomBackButton(
                                width: 18.w,
                                height: 18.w,
                                buttonType: CustomBackButtonType.close,
                                onPressed: onClose,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
