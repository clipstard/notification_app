part of 'package:notification_app/extensions/extensions.dart';

extension DurationFormatter on Duration {
  String formatSeconds() {
    return this.inSeconds.remainder(60).toString().padLeft(2, '0');
  }

  String formatMinutes() {
    return this.inMinutes.remainder(60).toString().padLeft(2, '0');
  }

  String formatHours() {
    return this.inHours.toString().padLeft(2, '0');
  }

  String minuteTimerFormat() {
    return '${this.formatMinutes()}:${this.formatSeconds()}';
  }

  String hourTimerFormat() {
    return '${this.formatHours()}:${this.minuteTimerFormat()}';
  }
}
