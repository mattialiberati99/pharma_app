import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../helpers/app_config.dart';
import '../../helpers/validators.dart';
import '../../providers/user_provider.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  GlobalKey<FormState>? loginFormKey = GlobalKey<FormState>();
  bool hidePassword = true;

  _aggiorna() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  bool em = false;
  bool ps = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(milliseconds: 500), () => FlutterNativeSplash.remove());

    if (kDebugMode) {
      print('Current User API Token:${currentUser.value.apiToken}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = ref.watch(userProvider);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.mqw * 0.06,
        ),
        width: App(context).appWidth(100),
        child: Form(
          key: loginFormKey,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Image(
                      width: 8.w,
                      height: 5.h,
                      image: const AssetImage(
                          'assets/immagini_pharma/logo_small.png'),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    'Accedi',
                    style: context.textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, bottom: 3),
                        child: Text(
                          'Email',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 167, 166, 165),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 362,
                        height: em ? 44 : 64,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'example@emailexample',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true,
                            fillColor: Color.fromARGB(255, 239, 242, 241),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, color: Colors.transparent)),
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 205, 207, 206)),
                          ),
                          onSaved: (input) => currentUser.value.email = input,
                          validator: (input) {
                            Validators.validateEmail(input);
                            if (input != null) {
                              setState(() {
                                em = true;
                              });
                            } else {
                              setState(() {
                                em = false;
                              });
                            }
                            return null;
                          },
                          //prefixIcon: Icon(Icons.email,color: Colors.white,),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, bottom: 3),
                        child: const Text(
                          'Password',
                          style: TextStyle(
                              color: Color.fromARGB(255, 167, 166, 165),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 362,
                        height: ps ? 44 : 64,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Min 8 cifre',
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 239, 242, 241),
                            suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: hidePassword
                                    ? GestureDetector(
                                        child: Image(
                                          color: const Color.fromARGB(
                                              255, 167, 166, 165),
                                          width: 0.1.w,
                                          height: 0.1.h,
                                          fit: BoxFit.contain,
                                          image: const AssetImage(
                                              'assets/immagini_pharma/eye.png'),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                      )
                                    : GestureDetector(
                                        child: Image(
                                          color: const Color.fromARGB(
                                              255, 167, 166, 165),
                                          width: 0.1.w,
                                          height: 0.1.h,
                                          fit: BoxFit.contain,
                                          image: const AssetImage(
                                              'assets/immagini_pharma/eye_op.png'),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                      )),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, color: Colors.transparent)),
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 205, 207, 206)),
                          ),

                          onSaved: (input) =>
                              currentUser.value.password = input,
                          validator: (input) {
                            Validators.validatePassword(input, context);
                            if (input != null) {
                              setState(() {
                                ps = true;
                              });
                            } else {
                              setState(() {
                                ps = false;
                              });
                            }
                            return null;
                          },
                          obscureText: hidePassword,

                          //prefixIcon: Icon(Icons.lock,color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('ForgetPassword'),
                          child: Text(
                            'Password dimenticata?',
                            style: context.textTheme.titleSmall?.copyWith(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 47, 161, 148)),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 50.w,
                          height: 5.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (loginFormKey!.currentState!.validate()) {
                                loginFormKey!.currentState!.save();
                                userProv.login(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 47, 161, 148),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            child: const Text('Accedi'),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                          image: AssetImage('assets/immagini_pharma/Line.png')),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Oppure',
                        style: TextStyle(
                            color: Color.fromARGB(255, 202, 202, 202),
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image(
                          image: AssetImage('assets/immagini_pharma/Line.png')),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 50.w,
                          height: 5.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('Home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            child: const Text('Accedi come ospite'),
                          )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 1.h),
                      if (Platform.isIOS)
                        SizedBox(
                          width: 50.w,
                          height: 5.h,
                          child: ElevatedButton.icon(
                            onPressed: () => userProv.signInWithApple(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                'assets/ico/logo_apple_white.svg',
                                height: 30,
                                width: 30,
                              ),
                            ),
                            label: const Text('Accedi con Apple'),
                          ),
                        ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        width: 50.w,
                        height: 5.h,
                        child: ElevatedButton.icon(
                          onPressed: () => userProv.loginGoogle(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                              'assets/ico/google-icon.svg',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          label: const Text('Accedi con Google'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Non hai un account?',
                        style: context.textTheme.titleSmall
                            ?.copyWith(fontSize: 14, color: AppColors.gray4),
                      ),
                      TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed('SignUp', arguments: false),
                          child: Text(
                            'Iscriviti',
                            style: context.textTheme.titleSmall?.copyWith(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 47, 161, 148)),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
