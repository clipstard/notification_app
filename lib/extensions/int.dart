part of 'package:notification_app/extensions/extensions.dart';

extension Corrector on int {
  int negativeToZero() {
    if (this < 0) {
      return 0;
    }
    return this;
  }
}
