import 'package:flutter/material.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/presentation/widgets/builders/gradient_builder.dart';

class ScrollablePage extends StatelessWidget {
  ScrollablePage({
    required this.child,
    this.intrinsicHeight = false,
    this.bgGradient = false,
  });

  final Widget child;
  final bool intrinsicHeight;
  final bool bgGradient;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2!,
      child: LayoutBuilder(builder: (
        BuildContext context,
        BoxConstraints viewportConstraints,
      ) {
        return Container(
          width: viewportConstraints.maxWidth,
          decoration: BoxDecoration(
            gradient: bgGradient ? GradientBuilder.gradientBackground() : null,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: Dimension.xAxisPadding,
              right: Dimension.xAxisPadding,
              bottom: Dimension.yAxisPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    viewportConstraints.maxHeight - Dimension.yAxisPadding,
              ),
              child: _buildChildWidget(child),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSafeArea(Widget child) {
    return SafeArea(
      child: child,
      top: true,
      bottom: true,
    );
  }

  Widget _buildChildWidget(Widget child) {
    if (intrinsicHeight) {
      return IntrinsicHeight(
        child: _buildSafeArea(child),
      );
    }

    return _buildSafeArea(child);
  }
}
