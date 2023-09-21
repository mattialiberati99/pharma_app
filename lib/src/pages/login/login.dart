import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/custom_toggle.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/login/widgets/CustomTextFormField.dart';
import 'package:pharma_app/src/pages/login/widgets/button_border_icon.dart';

import '../../components/divider_label.dart';
import '../../components/social_login_row.dart';
import '../../helpers/app_config.dart';
import '../../helpers/validators.dart';
import '../../models/user.dart';
import '../../providers/selected_page_name_provider.dart';
import '../../providers/user_provider.dart';
import '../../repository/auth_service.dart';
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
                    child: const Image(
                      width: 33,
                      height: 32,
                      image:
                          AssetImage('assets/immagini_pharma/logo_small.png'),
                    ),
                  ),
                  const SizedBox(
                      // height: 50,
                      ),
                  Text(
                    'Accedi',
                    style: context.textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 3),
                        child: const Text(
                          'Email',
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
                          },
                          //prefixIcon: Icon(Icons.email,color: Colors.white,),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 3),
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
                            fillColor: Color.fromARGB(255, 239, 242, 241),
                            suffixIcon: Padding(
                                padding: EdgeInsets.all(2),
                                child: hidePassword
                                    ? GestureDetector(
                                        child: const Image(
                                          color: Color.fromARGB(
                                              255, 167, 166, 165),
                                          width: 22,
                                          height: 22,
                                          image: AssetImage(
                                              'assets/immagini_pharma/eye.png'),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                      )
                                    : GestureDetector(
                                        child: const Image(
                                          color: Color.fromARGB(
                                              255, 167, 166, 165),
                                          width: 22,
                                          height: 22,
                                          image: AssetImage(
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
                            style: context.textTheme.subtitle2?.copyWith(
                                fontSize: 14,
                                color: Color.fromARGB(255, 47, 161, 148)),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 210,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => userProv.login(context),
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
                  const SizedBox(
                    height: 20,
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
                  SocialLogin(
                    margin: context.mqw * 0.06,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Non hai un account?',
                        style: context.textTheme.subtitle2
                            ?.copyWith(fontSize: 14, color: AppColors.gray4),
                      ),
                      TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed('SignUp', arguments: false),
                          child: Text(
                            'Iscriviti',
                            style: context.textTheme.subtitle2?.copyWith(
                                fontSize: 14,
                                color: Color.fromARGB(255, 47, 161, 148)),
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
