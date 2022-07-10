part of 'package:notification_app/extensions/extensions.dart';

extension Trimmer on String {
  String toSingleLine() {
    return this.replaceAll('\n', '');
  }

  String reduceSpaces() {
    return this.replaceAll(new RegExp(r'[\s]{2,}'), ' ');
  }

  String backwardSubstring(int length) {
    return this.substring((this.length - length).negativeToZero(), this.length);
  }

  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}
