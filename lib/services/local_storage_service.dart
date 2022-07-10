import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  late SharedPreferences _prefs;

  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String appFirstRunKey = 'FIRST_RUN';
  static const String introPageSeenKey = 'INTRO_PAGE_SEEN';
  static const String biometricLoginKey = 'USE_BIOMETRIC_LOGIN';
  static const String msisdnKey = 'USER_MSISDN';
  static const String userFirstNameKey = 'USER_NAME';
  static const String rememberMeKey = 'USER_REMEMBER_ME';
  static const String isFirstLoginKey = 'IS_FIRST_LOGIN';
  static const String profileCompletionKey = 'CLOSED_PROFILE_COMPLETION';
  static const String successfulFormLoginsCountKey = 'SUCCESSFUL_LOGINS_COUNT';

  /// Predefined get/set for easiest usage
  ///
  /// Biometric Consent
  bool get biometricLoginActivated {
    bool? value = _prefs.getBool(biometricLoginKey);
    return value ?? false;
  }

  set biometricLoginActivated(bool value) {
    _prefs.setBool(biometricLoginKey, value);
  }

  /// First Run of application
  ///
  bool get appFirstRun {
    bool? value = _prefs.getBool(appFirstRunKey);
    return value ?? true;
  }

  set appFirstRun(bool value) {
    _prefs.setBool(appFirstRunKey, value);
  }

  /// Intro Page Seen
  ///
  bool get introPageSeen {
    bool? value = _prefs.getBool(introPageSeenKey);
    return value ?? false;
  }

  set introPageSeen(bool value) {
    _prefs.setBool(introPageSeenKey, value);
  }

  /// User MSISDN
  ///
  String get msisdn {
    String? value = _prefs.getString(msisdnKey);
    return value ?? '';
  }

  set msisdn(String value) {
    _prefs.setString(msisdnKey, value);
  }

  /// User First Name
  ///
  String get userFirstName {
    String? value = _prefs.getString(userFirstNameKey);
    return value ?? '';
  }

  set userFirstName(String value) {
    _prefs.setString(userFirstNameKey, value);
  }

  /// User Remember Me
  ///
  bool get rememberMe {
    bool? value = _prefs.getBool(rememberMeKey);
    return value ?? true;
  }

  set rememberMe(bool value) {
    _prefs.setBool(rememberMeKey, value);
  }

  /// User First Login
  ///
  bool get isFirstLogin {
    bool? value = _prefs.getBool(isFirstLoginKey);
    return value ?? true;
  }

  set isFirstLogin(bool value) {
    _prefs.setBool(isFirstLoginKey, value);
  }

  /// Profile completion - Closed
  ///
  bool get closedProfileCompletion {
    bool? value = _prefs.getBool(profileCompletionKey);
    return value ?? false;
  }

  set closedProfileCompletion(bool value) {
    _prefs.setBool(profileCompletionKey, value);
  }

  /// Tracking successful form logins
  ///
  int get formLoginsCount {
    int? value = _prefs.getInt(successfulFormLoginsCountKey);
    return value ?? 0;
  }

  set formLoginsCount(int value) {
    _prefs.setInt(successfulFormLoginsCountKey, value);
  }

  Future<bool> remove(String key) async => await _prefs.remove(key);

  Future<bool> clear() async => await _prefs.clear();

  LocalStorage._internal();
}
