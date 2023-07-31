import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/login/success_verification_page.dart';
import 'package:pharma_app/src/pages/login/widgets/CustomTextFormField.dart';
import 'package:pharma_app/src/pages/login/widgets/button_border_icon.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

import '../../components/divider_label.dart';
import '../../components/social_login_row.dart';
import '../../helpers/app_config.dart';
import '../../helpers/validators.dart';

import '../../providers/selected_page_name_provider.dart';
import '../../repository/user_repository.dart';

class VerifyOtp extends ConsumerStatefulWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  String? _otpCode;
  int secondsRemaining = 59;
  bool enableResend = false;
  late Timer timer;
  final TextEditingController _inputController = TextEditingController();

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final userProv = ref.watch(userProvider);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.mqw * 0.06,
            ),
            width: App(context).appWidth(100),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  child: Image(
                    image: AssetImage('assets/immagini_pharma/logo_small.png'),
                    width: 33,
                    height: 32,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Codice',
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Codice inviato all\'e-mail',
                  style: context.textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 50,
                ),
                OtpTextField(
                  mainAxisAlignment: MainAxisAlignment.center,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  fieldWidth: 70,
                  showFieldAsBox: true,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  onSubmit: (code) {
                    setState(() {
                      _otpCode = code;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "($secondsRemaining)",
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        style: context.textTheme.titleSmall,
                        children: [
                          const TextSpan(text: 'Invia di nuovo? '),
                          TextSpan(
                              text: ' Clicca qui',
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  sendVerificationMail();
                                  print('invia di nuovo');
                                  secondsRemaining = 59;
                                  enableResend
                                      ? () {
                                          secondsRemaining == 0;
                                        }
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Potrai reinviare il codice al termine dei secondi.')));
                                }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 50,
                        width: 210,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_otpCode != null) {
                              Navigator.of(context).pushReplacementNamed(
                                  'SuccessVerificationPage');
                              // _verifyOtp(context, _otpCode!);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Inserire il codice a 4 cifre'),
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 47, 171, 148),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Verifica',
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _verifyOtp(BuildContext context, String otpCode) {}
