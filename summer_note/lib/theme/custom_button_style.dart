import 'dart:ui';
import 'package:summer_note/core/app_export.dart';
import 'package:flutter/material.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillLime => ElevatedButton.styleFrom(
        backgroundColor: appTheme.lime800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
      );

  // Gradient button style
  static BoxDecoration get gradientPrimaryToPrimaryDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(14.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.black90001.withOpacity(0.25),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment(0.08, 0),
          end: Alignment(1.0, 1),
          colors: [
            theme.colorScheme.primary.withOpacity(1),
            theme.colorScheme.primary,
          ],
        ),
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
