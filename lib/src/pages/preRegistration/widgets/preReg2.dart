import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PreReg2 extends ConsumerStatefulWidget {
  int indice;

  PreReg2(this.indice, {super.key});
  @override
  ConsumerState<PreReg2> createState() => _PreReg2State();
}

class _PreReg2State extends ConsumerState<PreReg2> {
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
      child: Column(
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
                  image: AssetImage('assets/immagini_pharma/Page2.png'),
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Farmacista online\n assistenza sanitaria',
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
