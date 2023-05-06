import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/login/verify_otp.dart';

import '../../helpers/app_config.dart';

class OtpScreenPROVA extends ConsumerStatefulWidget {
  const OtpScreenPROVA({super.key});

  @override
  ConsumerState<OtpScreenPROVA> createState() => _OtpScreenPROVA();
}

class _OtpScreenPROVA extends ConsumerState<OtpScreenPROVA> {
  TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(
        const Duration(milliseconds: 500), () => FlutterNativeSplash.remove());
    countryController.text = "+39";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: context.mqw * 0.06,
            ),
            width: App(context).appWidth(100),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        child: Image(
                          image: AssetImage(
                              'assets/immagini_pharma/logo_small.png'),
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Verifica numero',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Per continuare è necessario verificare il tuo numero di telefono!',
                        style: context.textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                child: TextField(
                                  controller: countryController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const Text(
                                "|",
                                style:
                                    TextStyle(fontSize: 33, color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Numero",
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VerifyOtp(),
                                ),
                              ),
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 47, 171, 148),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Manda codice',
                            ),
                          )),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
