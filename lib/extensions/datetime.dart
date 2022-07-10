part of 'package:notification_app/extensions/extensions.dart';

extension Formatter on DateTime {
  String format(String format) {
    return DateFormat(format).format(this);
  }

  String toUEFormat() {
    return this.format('yyyy-MM-dd HH:mm');
  }
}
