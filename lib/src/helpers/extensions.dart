import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

/// Extension methods for [BuildContext].
extension BuildContextX on BuildContext {
  /// Returns the nearest textTheme from the current context.
  TextTheme get textTheme => Theme.of(this).typography.white;

  /// Returns the nearest colorScheme from the current context.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns same as MediaQuery.of(context)
  MediaQueryData get mq => MediaQuery.of(this);
  /// Returns width & height
  double get mqw => MediaQuery.of(this).size.width;
  double get mqh => MediaQuery.of(this).size.height;

  bool get onSmallScreen => mqh <=600;
  /// Localizations
  S get loc => S.current;
}

extension DoubleX on double {
  /// Converts the double into a valid EUR String
  String toEUR({int? decimalDigit}) {
    return NumberFormat.currency(
      name: '',
      locale: 'en_IT',
      decimalDigits: 2,
      symbol: '€'
    ).format(this);
  }
}

// masks the given [text] with the given [mask] character
extension StringX on String {
  String mask() {
    return replaceRange(0, length - 4, '************')
        .replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ');
  }
}



