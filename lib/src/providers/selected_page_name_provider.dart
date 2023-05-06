import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

final selectedPageNameProvider =
    NotifierProvider<SelectedPageName, String>(SelectedPageName.new);

class SelectedPageName extends Notifier<String> {
  String _previousPageName = 'Home';

  @override
  String build() {
    if (currentUser.value.apiToken != null) {
      return 'Home';
    } else {
      return 'Login';
    }
  }

  //String get selectedPageName => state;
  String get previousPageName => _previousPageName;

  void setSelectedPageName(String pageName) {
    _previousPageName = state;
    state = pageName;
    if (kDebugMode) {
      print('STATE: $state');
    }
    if (kDebugMode) {
      print('SELECTED PAGE: $state');
    }
    if (kDebugMode) {
      print('PREVIOUS PAGE: $_previousPageName');
    }
  }

  void selectPage(BuildContext context, String pageName) {
    if (state != pageName) {
      setSelectedPageName(pageName);
    }
    // dismiss the drawer of the ancestor Scaffold if we have one
    if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
      Navigator.of(context).pop();
    }
  }

  void toPreviousPage(BuildContext context) {
    if (previousPageName != '') {
      setSelectedPageName(previousPageName);
    }
    // dismiss the drawer of the ancestor Scaffold if we have one
    // if (Scaffold.maybeOf(context)?.hasDrawer ?? false) {
    //   Navigator.of(context).pop();
    // }
  }

  void resetNavigation() {
    state = 'Home';
    _previousPageName = state;
  }

  // void emptyNavigation() {
  //   state = '';
  //   _previousPageName = state;
  // }

  void setLoginSelected() {
    state = 'Login';
    _previousPageName = '';
  }

  void setPrevious(String? selectedPage) {
    _previousPageName = selectedPage ?? state;
  }
}
