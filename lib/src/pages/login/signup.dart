import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/login/widgets/CustomTextFormField.dart';
import 'package:pharma_app/src/pages/login/widgets/button_border_icon.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

import '../../components/divider_label.dart';
import '../../components/social_login_row.dart';
import '../../helpers/app_config.dart';
import '../../helpers/validators.dart';

import '../../providers/selected_page_name_provider.dart';
import '../../repository/user_repository.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final passwordController = TextEditingController();
  bool hidePassword = true;
  bool agree = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500))
        .then((value) => FlutterNativeSplash.remove());
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = ref.watch(userProvider);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.mqw * 0.06,
            ),
            width: App(context).appWidth(100),
            child: Form(
              key: userProv.signupFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      child: Image(
                        image:
                            AssetImage('assets/immagini_pharma/logo_small.png'),
                        width: 33,
                        height: 32,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Iscriviti',
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 37,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nome e Cognome',
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                    CustomTextFormField(
                      hint: 'Mario Rossi',
                      textInputType: TextInputType.emailAddress,
                      onSaved: (String input) => currentUser.value.name = input,
                      validator: (String input) =>
                          Validators.validateUserName(input, context),
                      //prefixIcon: Icon(Icons.email,color: Colors.white,),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                    CustomTextFormField(
                      hint: 'example@emailexample',
                      textInputType: TextInputType.emailAddress,
                      onSaved: (input) => currentUser.value.email = input,
                      validator: (input) =>
                          Validators.validateEmail(input),
                      //prefixIcon: Icon(Icons.email,color: Colors.white,),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                    CustomTextFormField(
                      controller: passwordController,
                      hint: 'Min 8 cifre',
                      textInputType: TextInputType.text,
                      onSaved: (input) => currentUser.value.password = input,
                      validator: (input) =>
                          Validators.validatePassword(input, context),
                      obscureText: hidePassword,
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        color: AppColors.secondDarkColor,
                        icon: Icon(hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      //prefixIcon: Icon(Icons.lock,color: Colors.white,),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value ?? false;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Accetto i Termini & Privacy Policy',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 50,
                            width: 210,
                            child: ElevatedButton(
                              onPressed: agree
                                  ? () {
                                      userProv.register(context);
                                 
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 47, 171, 148),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Iscriviti',
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    const DividerLabel(
                      label: 'Oppure entra con',
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    SocialLogin(
                      margin: context.mqw * 0.06,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hai già un account?',
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontSize: 14, color: AppColors.gray3),
                        ),
                        TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed('Login',
                                    arguments: false),
                            child: Text(
                              'Login',
                              style: context.textTheme.titleSmall?.copyWith(
                                  fontSize: 14, color: AppColors.primary),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
