import 'package:flutter/material.dart';
import 'app_breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (AppBreakpoints.isMobile(width)) {
          return mobile;
        }

        if (AppBreakpoints.isTablet(width)) {
          return tablet ?? desktop;
        }

        return desktop;
      },
    );
  }
}
