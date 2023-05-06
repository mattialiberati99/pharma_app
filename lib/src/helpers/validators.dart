import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

/// Class for validating the input of a field
class Validators {
  static final ValueNotifier<bool> _validate = ValueNotifier<bool>(false);

  static bool get validate => _validate.value;

  static String? validateEmail(email, BuildContext context) {
    final emailRegExp = RegExp(r'^[\w-\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]+');

    if (email == null || !emailRegExp.hasMatch(email)) {
      _validate.value = false;
      return S.of(context).should_be_a_valid_email;
    } else {
      _validate.value = true;
      return null;
    }
  }

  static String? validatePassword(input, BuildContext context) {
    _validate.value = input.length < 6;
    if (input.length < 6) {
      _validate.value = false;
      return S.of(context).should_be_more_than_6_letters;
    } else {
      _validate.value = true;
      return null;
    }
  }

  static String? matchPassword(input, match, BuildContext context) {
    _validate.value = input.length < 6;
    if (input.length < 6) {
      _validate.value = false;
      return S.of(context).should_be_more_than_6_letters;
    } else if (input != match) {
      _validate.value = false;
      return S.of(context).password_not_match;
    } else {
      _validate.value = true;
      return null;
    }
  }

  static String? validateUserName(input, BuildContext context) {
    if (input.length <= 3) {
      _validate.value = false;
      return S.of(context).should_be_more_than_3_letters;
    } else {
      _validate.value = true;
      return null;
    }
  }

  static String validateNumber(input) {
    if (input.length < 1) {
      _validate.value = false;
      return "Inserire un numero";
    } else {
      _validate.value = true;
      return '';
    }
  }
}
