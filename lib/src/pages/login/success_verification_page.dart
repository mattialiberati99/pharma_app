import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/repository/user_repository.dart';
import '../../helpers/app_config.dart';

class SuccessVerificationPage extends StatelessWidget {
  const SuccessVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('Login'),
          ),
        ),
        body: SafeArea(
          child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: context.mqw * 0.06,
              ),
              width: App(context).appWidth(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    child: Image(
                      image:
                          AssetImage('assets/immagini_pharma/green_tick.png'),
                      width: 220,
                      height: 220,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Email verificata!',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Congratulazioni, la vostra email è stata verificata con successo. Potete iniziare a utilizzare l\'applicazione',
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 200),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacementNamed('Login'),
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 47, 171, 148),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Continua',
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
