class AppConfig {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  AppConfig._();

  /// Provided [phoneLength] excludes country prefix or other prefixes and
  /// watches only pure msisdn. Used for validation of MSISDN.
  static const int phoneLength = 9;

  /// Reminder to optin(enable) push notifications in case 'Maybe later' was
  /// choosen for the previous session.
  /// So that [pushNotificationsDelayDays] defines in how many days the consent
  /// screen will be shown again for the customer.
  static const int pushNotificationsDelayDays = 30;

  /// The [loyaltyProgramName] used for optin new customers
  static const String loyaltyProgramName = '3UK';

  /// The [inactivityTimeout] is used to logout the user during inactivity of
  /// the  app  defined in this constant.
  /// [inactivityTimeout] uses seconds and defaulted to 172800 = 48hours.
  static const int inactivityTimeout = 172800;

  /// [maxLoginAttempts] defines max tries to login with bad credentials without
  /// blocking the user, just prevention.
  static const int maxLoginAttempts = 3;

  /// [contactCenterNumber] used for call us feature
  static const String contactCenterNumber = '+447000001004';
}
