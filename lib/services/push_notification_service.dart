import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  final FirebaseMessaging _pushNotifications = FirebaseMessaging.instance;

  Future<void> init() async {
    await _pushNotifications.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Define Messaging stream events like [onMessage], [onMessageOpenedApp],
    /// [onBackgroundMessage] here.
  }

  Future<String?> getPushNotificationsToken() async {
    return await _pushNotifications.getToken();
  }

  Future<bool> requestPushNotificationPermissions() async {
    /// On Android, is it not required to call this method. If called however,
    /// a [NotificationSettings] class will be returned with
    /// [NotificationSettings.authorizationStatus] returning
    /// [AuthorizationStatus.authorized].
    NotificationSettings settings = await _pushNotifications.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return <AuthorizationStatus>[
      AuthorizationStatus.authorized,
      AuthorizationStatus.provisional
    ].contains(settings.authorizationStatus);
  }

  Future<bool> isPreviouslyRequestedPermission() async {
    NotificationSettings settings =
        await _pushNotifications.getNotificationSettings();

    return settings.authorizationStatus != AuthorizationStatus.notDetermined;
  }
}
