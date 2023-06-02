import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as Apple;

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<User> currentUser = ValueNotifier(User());

final userProvider = ChangeNotifierProvider<UserProvider>((ref) {
  return UserProvider();
});

class UserProvider with ChangeNotifier {
  static final String afterLoginPage = 'Home';
  static final String afterRegisterPage = 'VerifyOtp';

  GlobalKey<FormState>? loginFormKey;
  GlobalKey<FormState>? signupFormKey;

  late FirebaseMessaging _firebaseMessaging;
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  late String token;

  UserProvider() {
    loginFormKey = GlobalKey<FormState>();
    signupFormKey = GlobalKey<FormState>();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String? _deviceToken) {
      currentUser.value.deviceToken = _deviceToken;
      token = _deviceToken!;
      print(_deviceToken);
      print("TOOKEEENNN");
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  login(BuildContext context) async {
    if (loginFormKey!.currentState!.validate()) {
      loginFormKey!.currentState!.save();
      currentUser.value.deviceToken = token;
      userRepo.login(currentUser.value).then((value) {
        if (value.apiToken != null) {
          currentUser.value = value;
          saveUserToken();
          Navigator.of(context).pushReplacementNamed(afterLoginPage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_not_exist),
        ));
      });
    }
  }

  void register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (signupFormKey!.currentState!.validate()) {
      signupFormKey!.currentState!.save();
      currentUser.value.deviceToken = token;
      print(token);
      userRepo.register(currentUser.value).then((User? value) {
        if (value != null && value.apiToken != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registrazione effettuata con successo"),
          ));
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacementNamed(afterRegisterPage);
          });
          // TODO ? Navigator.of(scaffoldKey.currentContext!).pushReplacementNamed('ValidateEmail');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.current.wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.this_email_account_exists),
        ));
      });
    }
  }

  void resetPassword(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (loginFormKey!.currentState!.validate()) {
      loginFormKey!.currentState!.save();
      userRepo.resetPassword(currentUser.value).then((value) {
        if (value == true) {
          Navigator.of(context).pushReplacementNamed('VerifyCode');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.current.error_verify_email_settings),
          ));
        }
      });
    }
  }

  loginGoogle(BuildContext context) async {
    try {
      Auth.UserCredential userCredential;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final Auth.OAuthCredential googleAuthCredential =
          Auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      final authUser = userCredential.user;
      // scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Sign In ${user?.uid} with Google")));
      currentUser.value.name = authUser?.displayName ?? "username";
      currentUser.value.email = authUser?.email;
      currentUser.value.phone = authUser?.phoneNumber;
      socialLogin(authUser!.uid, context);
    } catch (e, stack) {
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
          (SnackBar(content: Text("Failed to sign in with Google: ${e}"))));
      print(e.toString());
    }
  }

  signInWithApple(BuildContext context) async {
    // 1. perform the sign-in request
    final Apple.AuthorizationResult result =
        await Apple.TheAppleSignIn.performRequests([
      const Apple.AppleIdRequest(
          requestedScopes: [Apple.Scope.email, Apple.Scope.fullName])
    ]);

    switch (result.status) {
      case Apple.AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = Auth.OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken:
              String.fromCharCodes(appleIdCredential!.identityToken!.skip(0)),
          accessToken: String.fromCharCodes(
              appleIdCredential.authorizationCode!.skip(0)),
        );

        final authResult = await _auth.signInWithCredential(credential);

        currentUser.value.email = authResult.user!.email!;
        currentUser.value.name = authResult.user!.displayName!;
        String token = authResult.user!.uid;
        socialLogin(token, context);
        break;
      case Apple.AuthorizationStatus.error:
        print(result.status);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.error.toString()),
        ));
        break;

      case Apple.AuthorizationStatus.cancelled:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Aborted By User"),
        ));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${result.status} - ${result.error.toString()} - ${result.credential?.email}"),
        ));
    }
  }

  socialLogin(String token, BuildContext context) {
    print("Performing social login...");
    FocusScope.of(context).unfocus();
    currentUser.value.deviceToken = token;

    userRepo.loginSocial(currentUser.value, token).then((User? value) {
      print("userRepository.loginSocial => $value");
      if (value != null && value.apiToken != null) {
        currentUser.value = value;
        saveUserToken();
        Navigator.of(context)
            .pushReplacementNamed(afterLoginPage, arguments: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.current.this_account_not_exist + "- $e"),
      ));
    });
  }

  Future<bool> firstAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    if (prefs.containsKey('first_access')) {
      return false;
    } else {
      return true;
    }
  }

  void setFirstAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_access', true);
  }

  static Future<void> logout() async {
    currentUser.value = User();
    clearTokens();
  }

  updateRemote() async {
    currentUser.value.deviceToken = token;
    userRepo.update(currentUser.value).then((value) {
      currentUser.value = value;
      saveUserToken();
      notifyListeners();
    });
  }

  loadUserFromSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    if (currentUser.value.auth == null && prefs.containsKey('user_token')) {
      print(prefs.get('user_token'));
      String token = await prefs.get('user_token') as String;
      currentUser.value = await userRepo.loginAsUserToken(token);
      if (currentUser.value.id != null) {
        currentUser.value.auth = true;
      }
    } else {
      currentUser.value = User();
    }
    notifyListeners();
  }

  static void saveUserToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', currentUser.value.apiToken!);
    } catch (e) {
      throw Exception(e);
    }
  }

  static void clearTokens() {
    cleanUserToken();
  }

  static void cleanUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }
}
