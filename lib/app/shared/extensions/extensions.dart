import 'package:flutter/material.dart';

/// ----------------------------
/// 🔹 Spacing Extensions
/// ----------------------------
extension SpaceExtension on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());
}

/// ----------------------------
/// 🔹 Padding Extensions
/// ----------------------------
extension PaddingExtension on Widget {
  Widget padAll(double value) => Padding(
    padding: EdgeInsets.all(value),
    child: this,
  );

  Widget padSymmetric({double v = 0, double h = 0}) => Padding(
    padding: EdgeInsets.symmetric(vertical: v, horizontal: h),
    child: this,
  );

  Widget padOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );
}

/// ----------------------------
/// 🔹 Visibility Extensions
/// ----------------------------
extension VisibilityExtension on Widget {
  Widget get visible => this;

  Widget get gone => 0.h;

  Widget show(bool condition) => condition ? this : 0.h;
}

/// ----------------------------
/// 🔹 Text Styling Extensions
/// ----------------------------
extension TextStyleExtension on Text {
  Text color(Color c) => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(color: c),
  );

  Text size(double s) => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(fontSize: s),
  );

  Text bold() => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
  );

  Text italic() => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
  );
}

/// ----------------------------
/// 🔹 Alignment Extensions
/// ----------------------------
extension AlignExtension on Widget {
  Widget center() => Center(child: this);

  Widget alignTopLeft() => Align(alignment: Alignment.topLeft, child: this);

  Widget alignTopRight() => Align(alignment: Alignment.topRight, child: this);

  Widget alignBottomLeft() => Align(alignment: Alignment.bottomLeft, child: this);

  Widget alignBottomRight() => Align(alignment: Alignment.bottomRight, child: this);
}

/// ----------------------------
/// 🔹 OnTap Extensions
/// ----------------------------
extension OnTapExtension on Widget {
  Widget onTap(VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: this,
  );
}