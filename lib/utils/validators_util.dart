import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Validators {
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static const int pwdMinLen = 12;
  static const int pwdMaxLen = 64;
  static final RegExp pwdRegExp =
      RegExp(r'^(?=.*[@#$%^&*+=`|{}:;!.?\"()\[\]-]).{12,64}$');

  /// Phone number RegExp specific to the Three UK.
  /// Allow phone numbers starting with 440 in development mode.
  static final RegExp phoneRegExp = kReleaseMode
      ? RegExp(r'^((07)|(447)|(\+447))[0-9]{9}$')
      : RegExp(r'^((07)|(447)|(440)|(\+447))[0-9]{9}$');

  /// Validator that requires the control have a non-empty value.
  static FormFieldValidator<String> required([String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return errorMessage ?? 'The field is required';
      else
        return null;
    };
  }

  /// Bool representation of [Validators.required] validator.
  static bool isNotEmpty(String value) => Validators.required()(value) == null;

  /// Validator that requires the control's value pass an Three UK
  /// phone number validation test.
  static FormFieldValidator<String> phone([String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return null;
      else {
        if (phoneRegExp.hasMatch(value))
          return null;
        else
          return errorMessage ?? 'Phone must be a valid phone number';
      }
    };
  }

  /// Bool representation of [Validators.phone] validator.
  static bool isValidPhone(String value) => Validators.phone()(value) == null;

  /// Validator that requires the control's value pass an email validation test.
  static FormFieldValidator<String> email([String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return null;
      else {
        if (emailRegExp.hasMatch(value))
          return null;
        else
          return errorMessage ?? 'Email must be a valid email address';
      }
    };
  }

  /// Bool representation of [Validators.email] validator.
  static bool isValidEmail(String value) => Validators.email()(value) == null;

  /// Validator that requires the control's value pass an password
  /// validation test.
  static FormFieldValidator<String> password([String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return null;
      else {
        if (pwdRegExp.hasMatch(value))
          return null;
        else
          return errorMessage ??
              'Password must be $pwdMinLen-$pwdMaxLen characters long' +
                  ' and contain special characters';
      }
    };
  }

  /// Bool representation of [Validators.password] validator.
  static bool isValidPassword(String value) =>
      Validators.password()(value) == null;

  /// Validator that requires the control's value to match a regex pattern.
  static FormFieldValidator<String> patternRegExp(RegExp pattern,
      [String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty) return null;

      if (pattern.hasMatch(value))
        return null;
      else
        return errorMessage ?? 'The field is not valid';
    };
  }

  /// Bool representation of [Validators.patternRegExp] validator.
  static bool isValidPatternRegExp(RegExp pattern, String value) =>
      Validators.patternRegExp(pattern)(value) == null;

  /// Validator that requires the control's value to match a pattern.
  static FormFieldValidator<String> pattern(String pattern,
      [String? errorMessage]) {
    return patternRegExp(RegExp(pattern), errorMessage);
  }

  /// Bool representation of [Validators.pattern] validator.
  static bool isValidPattern(String pattern, String value) =>
      Validators.pattern(pattern)(value) == null;

  /// Validator that requires the control's value to be greater than or equal
  /// to the provided number.
  static FormFieldValidator<String> minLength(int minLength,
      [String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty) return null;

      if (value.length < minLength)
        return errorMessage ??
            'The field must be at least $minLength characters long';
      else
        return null;
    };
  }

  /// Bool representation of [Validators.minLength] validator.
  static bool isValidMinLength(int minLength, String value) =>
      Validators.minLength(minLength)(value) == null;

  /// Validator that requires the length of the control's value to be less
  /// than or equal.
  static FormFieldValidator<String> maxLength(int maxLength,
      [String? errorMessage]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty) return null;

      if (value.length > maxLength)
        return errorMessage ??
            'The field must be not more than $maxLength characters long';
      else
        return null;
    };
  }

  /// Bool representation of [Validators.maxLength] validator.
  static bool isValidMaxLength(int minLength, String value) =>
      Validators.maxLength(minLength)(value) == null;

  /// Validator that requires the control's value to match provided value.
  static FormFieldValidator<String> match(
    String compare, [
    bool caseSensitive = true,
    String? errorMessage,
  ]) {
    return (String? value) {
      if (value == null) {
        value = '';
      }

      if (value.isEmpty) return null;

      if ((caseSensitive && value != compare) ||
          (!caseSensitive && value.toLowerCase() != compare.toLowerCase()))
        return errorMessage ?? 'The fields does not match.';
      else
        return null;
    };
  }

  /// Bool representation of [Validators.match] validator.
  static bool isValuesMatches(String compare, String value) =>
      Validators.match(compare)(value) == null;

  /// Compose multiple validators into a single one.
  ///
  /// Validate that the field is required and valid email address
  /// ```
  /// TextFormField(
  ///   decoration: InputDecoration(
  ///     labelText: 'Email',
  ///    ),
  ///   validator: Validators.compose([
  ///     Validators.required('Email is required'),
  ///     Validators.email('Invalid email address'),
  ///   ]),
  ///  ),
  /// ```
  ///
  static FormFieldValidator<String> compose(
      List<FormFieldValidator<String>> validators) {
    return (String? value) {
      for (final FormFieldValidator<String> validator in validators) {
        final String? result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Validator that requires the control's value to be a valid date
  /// that matches the provided  format
  static FormFieldValidator<String> calendarDate(
      String dateFormat, String errorMessage) {
    return (String? value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return null;
      else {
        try {
          DateFormat(dateFormat).parseStrict(value);
        } catch (e) {
          return errorMessage;
        }
        return null;
      }
    };
  }
}
