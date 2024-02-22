import 'package:flutter/material.dart';

Widget get spaceHeight5 => const SizedBox(height: 5);

Widget get spaceHeight10 => const SizedBox(height: 10);

Widget get spaceHeight15 => const SizedBox(height: 15);

Widget get spaceHeight20 => const SizedBox(height: 20);

Widget get spaceHeight25 => const SizedBox(height: 25);

Widget get spaceWeight5 => const SizedBox(width: 5);

Widget get spaceWeight10 => const SizedBox(width: 10);

Widget get spaceWeight15 => const SizedBox(width: 15);

Widget get spaceWeight20 => const SizedBox(width: 20);

Widget get spaceWeight25 => const SizedBox(width: 25);

Widget get spaceZero => const SizedBox.shrink();

Radius radiusCircular(double value) => Radius.circular(value);

BorderRadiusGeometry borderRadiusCircular(double value) => BorderRadius.circular(value);

double getAppSizeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getAppSizeWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class ThemeUtility {
  static const double baseHeight = 812.0;
  static const double baseWidth = 375.0;

  static double screenAwareHeight(double size, BuildContext context) {
    final double drawingHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return size * drawingHeight / baseHeight;
  }

  static double screenAwareWidth(double size, BuildContext context) {
    final double drawingWidth = MediaQuery.of(context).size.width;
    return size * drawingWidth / baseWidth;
  }
}

const kDefaultPadding = 20.0;
