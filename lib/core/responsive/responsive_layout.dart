import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.padding = const EdgeInsets.all(16),
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final contentWidth = maxWidth == null
            ? availableWidth
            : availableWidth.clamp(
                0.0,
                maxWidth!,
              ).toDouble();

        return Align(
          alignment: alignment,
          child: SizedBox(
            width: contentWidth,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}