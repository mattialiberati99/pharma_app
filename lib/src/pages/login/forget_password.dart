import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/AppButton.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../components/CustomTextFormField.dart';
import '../../components/custom_app_bar.dart';
import '../../helpers/app_config.dart' as config;
import '../../helpers/app_config.dart';
import '../../helpers/flat_button.dart';

import '../../helpers/validators.dart';
import '../../providers/user_provider.dart';

class ForgetPasswordWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ForgetPasswordWidget> createState() =>
      _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends ConsumerState<ForgetPasswordWidget> {
  GlobalKey _resetPasswordPageKey = GlobalKey();
  GlobalKey _loginPasswordPageKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = ref.watch(userProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _resetPasswordPageKey,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.accentColor,
      body: Container(
        key: const ValueKey('forget_password_container'),
        padding: const EdgeInsets.only(right: 24, left: 24, top: 24),
        width: config.App(context).appWidth(100),
        child: Form(
          key: userProv.forgetPasswordFormKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).forgot_password.toUpperCase(),
                    style: ExtraTextStyles.bigBlackBold),
                const SizedBox(height: 10),
                Text(S.current.email_to_reset_password,
                    style: ExtraTextStyles.normalBlack),
                const SizedBox(
                  height: 40,
                ),
                CustomTextFormField(
                  onSaved: (input) => currentUser.value.email = input,
                  validator: (input) => Validators.validateEmail(input),
                  hint: S.current.email,
                  textInputType: TextInputType.emailAddress,
                  //style: TextStyles.normalBlack,
                ),
                const SizedBox(height: 30),
                AppButton(
                  buttonText: S.of(context).send_password_reset_link,
                  onPressed: () {
                    userProv.resetPassword(context);
                  },
                ),
                const SizedBox(height: 30),
                FlatButton(
                    key: _loginPasswordPageKey,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('Login');
                    },
                    child: Text(
                      S.of(context).i_remember_my_password_return_to_login,
                      style: ExtraTextStyles.normalPrimary,
                    )),
              ]),
        ),
      ),
    );
  }
}
