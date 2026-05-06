import 'package:flutter/material.dart';

enum ScreenSize { phone, tablet }

class ResponsiveLayout {
  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 ? ScreenSize.tablet : ScreenSize.phone;
  }

  static bool isTablet(BuildContext context) => of(context) == ScreenSize.tablet;
  static bool isPhone(BuildContext context) => of(context) == ScreenSize.phone;
}
