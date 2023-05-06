// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pharma_app/src/providers/selected_page_name_provider.dart';
// import 'package:pharma_app/src/providers/user_provider.dart';
// import '../repository/user_repository.dart' as userRepository;
//
//
// import '../models/user.dart';
//
// class AuthService {
//
//   final Ref ref;
//
//   AuthService(this.ref);
//
//   ValueNotifier<User> currentUser = ValueNotifier(User());
//
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   void dispose() => currentUser.dispose();
//
//   Future<String?> register() async {
//     final user = ref.watch(userProvider);
//     if (kDebugMode) {
//       print('USER: ${user}');
//     }
//     userRepository.register(user).then((User? value) {
//       if (value != null && value.apiToken != null) {
//         if (kDebugMode) {
//           print('API TOKEN: ${value.apiToken}');
//         }
//         return 'Registrazione avvenuta con successo';
//       }
//     }).catchError((e) {
//     print(e);
//     return 'Mail exists';
//     // }).whenComplete(() {
//     //   Helper.hideLoader(loader);
//     // });
//     });
//     return 'Wrong mail or password';
//   }
//
//   Future<String?> login(BuildContext context) async {
//     final user = ref.watch(userProvider);
//     if (kDebugMode) {
//       print('USER: ${user}');
//     }
//     userRepository.login(user).then((User? value) {
//       if (value != null && value.apiToken != null) {
//         if (kDebugMode) {
//           print('API TOKEN: ${value.apiToken}');
//         }
//         ref.read(selectedPageNameProvider.notifier).resetNavigation();
//         ref.read(selectedPageNameProvider.notifier).selectPage(context, 'Home');
//
//         // Navigator.of(context)
//         //     .pushReplacementNamed('MainPage');
//         return 'Login OK';
//       }
//     }).catchError((e) {
//       if (kDebugMode) {
//         print(e);
//       }
//       return 'Mail KO';
//       // }).whenComplete(() {
//       //   Helper.hideLoader(loader);
//       // });
//     });
//     return 'Account KO';
//   }
//
//   Future<void> logout(BuildContext context)  async {
//     userRepository.logout();
//     //ref.read(selectedPageNameProvider.notifier).emptyNavigation();
//     ref.read(selectedPageNameProvider.notifier).selectPage(context, 'Login');
//   }
// }