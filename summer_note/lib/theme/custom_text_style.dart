import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyMedium14 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 14.fSize,
      );
  static get bodyMediumInter => theme.textTheme.bodyMedium!.inter;
  static get bodySmallOnError => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
      );
  // Headline text style
  static get headlineLargePrimary => theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.primary.withOpacity(1),
      );
  static get headlineSmallBold => theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  // Title text style
  static get titleLarge23 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 23.fSize,
      );
  static get titleLargeInter => theme.textTheme.titleLarge!.inter;
  static get titleLargeInterGray600 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w400,
      );
  static get titleLargeInterOnError =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontWeight: FontWeight.w400,
      );
  static get titleLargeInterOnErrorExtraBold =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontWeight: FontWeight.w800,
      );
  static get titleLargeInterSemiBold =>
      theme.textTheme.titleLarge!.inter.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleLargeLektonGray600 =>
      theme.textTheme.titleLarge!.lekton.copyWith(
        color: appTheme.gray600,
      );
  static get titleLargeSemiBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleMediumInter => theme.textTheme.titleMedium!.inter;
  static get titleMediumOnError => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onError.withOpacity(1),
        fontSize: 19.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallPoppins => theme.textTheme.titleSmall!.poppins;
}

extension on TextStyle {
  TextStyle get lekton {
    return copyWith(
      fontFamily: 'Lekton',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }
}
