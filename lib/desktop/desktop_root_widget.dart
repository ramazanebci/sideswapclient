import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/pin/d_pin_protection.dart';
import 'package:sideswap/desktop/route_generator.dart';
import 'package:sideswap/listeners/endpoint_listener.dart';
import 'package:sideswap/listeners/jade_status_listener.dart';
import 'package:sideswap/listeners/pin_listener.dart';
import 'package:sideswap/listeners/sideswap_notification_listener.dart';
import 'package:sideswap/listeners/warmup_app_listener.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

class DesktopRootWidget extends HookConsumerWidget {
  const DesktopRootWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);

    useEffect(() {
      Future<bool> onPinBlockade(String? title, bool showBackButton,
          PinKeyboardAcceptType iconType) async {
        final ret = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Material(
              child: DPinProtection(
                title: title,
                showBackButton: showBackButton,
                iconType: iconType,
              ),
            );
          },
        );
        ref.read(pinProtectionProvider).deinit();
        return ret ?? false;
      }

      ref.read(pinProtectionProvider).onPinBlockadeCallback = onPinBlockade;
      ref.read(localNotificationsProvider).init();

      return;
    }, const []);

    final serverLoginState = ref.watch(serverLoginStateProvider);

    useEffect(() {
      (switch (serverLoginState) {
        ServerLoginStateError(message: String msg) =>
          Future.microtask(() async {
            await ref.read(utilsProvider).showErrorDialog(msg);
            ref.read(walletProvider).cleanupConnectionStates();
            ref.read(warmupAppProvider.notifier).reinitialize();
          }),
        _ => () {}(),
      });

      return;
    }, [serverLoginState]);

    return Stack(
      children: [
        const PinListener(),
        const RouteContainer(),
        const SideswapNotificationListener(),
        const EndpointListener(),
        const JadeStatusListener(),
        const WarmupAppListener(),
        // TODO: WillPopScope is needed here? Check this
        WillPopScope(
          onWillPop: () async {
            // https://github.com/flutter/flutter/issues/66349
            final ret = await navigatorKey.currentState?.maybePop() ?? false;
            return !ret;
          },
          child: Navigator(
            key: navigatorKey,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            onUnknownRoute: RouteGenerator.errorRoute,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final env = ref.watch(envProvider);
            return switch (env) {
              0 => const SizedBox(),
              _ => Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 5,
                      ),
                      child: Text(
                        envName(env),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            };
          },
        ),
      ],
    );
  }
}
