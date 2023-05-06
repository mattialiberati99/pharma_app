import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PreReg3 extends ConsumerStatefulWidget {
  int indice;

  PreReg3(this.indice, {super.key});

  @override
  ConsumerState<PreReg3> createState() => _PreReg3State();
}

class _PreReg3State extends ConsumerState<PreReg3> {
  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: 500), () => FlutterNativeSplash.remove());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
       height: MediaQuery.of(context).size.height * 0.72,
      child:  Column(
        
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Column(children: const [
                  Image(
                    width: 250,
                    height: 250,
                    image: AssetImage('assets/immagini_pharma/Page3.png'),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Consegna in tempo\n o salta la fila',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 9, 15, 71),
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
           
          ],
        ),
      
    );
  }
}
