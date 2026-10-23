class AppBreakpoints {
  AppBreakpoints._();

  // Screen width breakpoints
  static const double mobile = 600;
  static const double desktop = 1024;

  // Maximum content width
  static const double maxContentWidth = 1440;

  // Responsive checks
  static bool isMobile(double width) {
    return width < mobile;
  }

  static bool isTablet(double width) {
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(double width) {
    return width >= desktop;
  }
}
