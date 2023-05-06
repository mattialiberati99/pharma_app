/// Class for validating the input of a field
class StringValidators {
  /// Validates a mail address
  static String? isEmailValid(String? email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]+');

    if (email == null || !emailRegExp.hasMatch(email)) {
      return 'Please Enter a Valid Email';
    }

    return null;
  }

  /// Validates a username
  static String? isUsernameValid(String? username) {
    if (username == null || username.isEmpty) {
      return 'Please Enter a Username';
    }

    if (username.length < 4) {
      return 'Username must be at least 4 characters';
    }

    if (username.length > 20) {
      return 'Username must be less than 20 characters';
    }

    return null;
  }

  /// Validate company name
  static String? isValidCompany(String? company) {
    if (company == null || company.isEmpty) {
      return 'Please enter a valid company';
    }

    return null;
  }

  /// Validate date
  static String? isValidDate(String? date) {
    final dateRegExp = RegExp(
        r'^(0[1-9]|1[0-2])([/+-])(0[1-9]|1[0-9]|2[0-9]|3[0,1])([/+-])(19|20)[0-9]{2}$');

    if (date == null || !dateRegExp.hasMatch(date)) {
      return 'Please enter a valid birth date - (MM/DD/YYYY)';
    }

    return null;
  }

  /// Validate password
  static String? isValidPassword(String? password) {
    if (password!.length < 6) {
      return 'Passwords must to be at least 6 characters';
    }
    return null;
  }

  /// Validate matching passwords
  static String? isValidConfirmedPassword(
    String? password,
    String? confirmedPassword,
  ) {
    if (password != confirmedPassword) return 'Passwords must match.';
    return null;
  }

  /// Validate currency USD format
  static String? isValidUsCurrency(String? currency) {
    final validCurrency =
        RegExp(r'^\$?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(\.[0-9][0-9])?$');
    if (currency == null || !validCurrency.hasMatch(currency)) {
      return 'Enter a valid amount';
    }
    return null;
  }

  ///Validate generic non empty string
  static String? isValidName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please select or type a valid source.';
    }

    return null;
  }
}
