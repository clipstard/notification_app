import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Color bckgndColor;
  final Color progressColor;

  /// [0,1]
  final double _progress;
  final double height;
  final double borderWidth;

  ProgressBar(double progress, this.bckgndColor, this.progressColor,
      this.height, this.borderWidth)
      : _progress = (progress < 0 ? 0 : (progress > 1 ? 1 : progress));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Bckgnd
        Container(
          decoration: BoxDecoration(
            color: bckgndColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: this.height,
        ),
        //Progress
        FractionallySizedBox(
          widthFactor: _progress,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: bckgndColor, width: borderWidth),
              color: progressColor,
              borderRadius: BorderRadius.all(Radius.circular(this.height)),
            ),
            height: this.height,
          ),
        ),
      ],
    );
  }
}
