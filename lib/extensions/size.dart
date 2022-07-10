part of 'package:notification_app/extensions/extensions.dart';

extension AspectRatio on Size {
  Size aspectRatioByWidth(double newWidth) {
    final double newHeight = (this.height / this.width) * newWidth;

    return Size(
      newWidth,
      newHeight,
    );
  }

  Size aspectRatioByHeight(double newHeight) {
    final double newWidth = (this.width / this.height) * newHeight;

    return Size(
      newWidth,
      newHeight,
    );
  }
}
