import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show InitializationSettings;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sideswap_notifications_platform_interface/src/sideswap_notification_types.dart';

abstract class SideswapNotificationsPlatformInterface
    extends PlatformInterface {
  /// Constructs a SideswapNotificationsPlatformInterfacePlatform.
  SideswapNotificationsPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static late SideswapNotificationsPlatformInterface _instance;

  /// The default instance of [SideswapNotificationsPlatformInterface] to use.
  static SideswapNotificationsPlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SideswapNotificationsPlatformInterface] when
  /// they register themselves.
  static set instance(SideswapNotificationsPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> firebaseInitializeApp() async {
    throw UnimplementedError(
        'firebaseInitializeApp() has not been implemented');
  }

  Future<void> notificationsInitialize({
    required TNotificationBackgroundHandler notificationBackgroundHandler,
    THandleIncomingNotification? handleIncomingNotification,
  }) async {
    throw UnimplementedError(
        'notificationServiceProviderInit() has not been implemented');
  }

  Future<void> firebaseRefreshToken({
    TRefreshTokenCallback? refreshTokenCallback,
  }) async {
    throw UnimplementedError('firebaseRefreshToken() has not been implemented');
  }

  InitializationSettings getLocalNotificationsInitializationSettings({
    Future<dynamic> Function(int, String?, String?, String?)?
        onDidReceiveLocalNotification,
  }) {
    throw UnimplementedError(
        'getLocalNotificationsInitializationSettings() has not been implemented');
  }
}
