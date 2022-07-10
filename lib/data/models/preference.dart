import 'dart:convert' show json;

import 'package:notification_app/extensions/extensions.dart' show Trimmer;

class Preference {
  final String name;
  final String value;

  Preference({
    required this.name,
    required this.value,
  });

  factory Preference.fromJson(dynamic json) => Preference(
        name: json['name'] as String,
        value: json['value'] as String,
      );

  Map<String, String> toJson() => <String, String>{
        'name': this.name,
        'value': this.value,
      };

  @override
  String toString() {
    return json.encode(toJson()).toSingleLine().reduceSpaces();
  }
}
