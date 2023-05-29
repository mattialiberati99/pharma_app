import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PreReg1 extends ConsumerStatefulWidget {
  int indice;

  PreReg1(this.indice, {super.key});

  @override
  ConsumerState<PreReg1> createState() => _PreReg1State();
}

class _PreReg1State extends ConsumerState<PreReg1> {
  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: 500), () => FlutterNativeSplash.remove());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Column(
                  children: const [
                    Image(
                      width: 250,
                      height: 250,
                      image: AssetImage('assets/immagini_pharma/Page1.png'),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Visualizzare e\n acquistare farmaci\n online con o\n senza ricetta',
                      style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 9, 15, 71),
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
