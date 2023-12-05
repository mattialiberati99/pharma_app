import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../helpers/app_config.dart';

class Aestetic extends StatelessWidget {
  const Aestetic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(165, 50),
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)))),
              child: const Text(
                'Torna alla Home',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('Home');
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: const [
            Image(
                image: AssetImage(
                    'assets/immagini_pharma/illustration_delivery.png')),
            SizedBox(
              height: 50,
            ),
            Text(
              'Il tuo ordine è in fase di',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'lavorazione!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
