import 'dart:convert' show json;
import 'package:notification_app/extensions/extensions.dart' show Trimmer;

import 'custom_field.dart';

class User {
  final String firstName;
  final String lastName;
  final Map<String, dynamic> userIds;
  final String? dob;
  final String? password;
  final List<CustomField> customFields;

  User({
    this.firstName = '',
    this.lastName = '',
    this.userIds = const <String, dynamic>{},
    this.dob,
    this.password,
    this.customFields = const <CustomField>[],
  });

  factory User.fromJson(dynamic json) {
    List<CustomField> getCustomFields(dynamic data) {
      return ((data ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => CustomField.fromJson(e))
          .toList();
    }

    return User(
      firstName: (json['firstName'] ?? '') as String,
      lastName: (json['lastName'] ?? '') as String,
      userIds: (json['userIds'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      dob: json['dob'] != null ? json['dob'] as String : null,
      password: json['password'] != null ? json['password'] as String : null,
      customFields:
          getCustomFields(json['customFields'] ?? const <CustomField>[]),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstName': this.firstName,
      'lastName': this.lastName,
      'userIds': this.userIds,
      'dob': this.dob,
      'password': this.password,
      'customFields':
          customFields.map((CustomField entry) => entry.toJson()).toList(),
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    Map<String, dynamic>? userIds,
    String? dob,
    String? msisdn,
    String? password,
    List<CustomField>? customFields,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userIds: userIds ?? this.userIds,
      dob: dob ?? this.dob,
      password: password ?? this.password,
      customFields: customFields ?? this.customFields,
    );
  }

  @override
  String toString() {
    return json.encode(toJson()).toSingleLine().reduceSpaces();
  }
}
