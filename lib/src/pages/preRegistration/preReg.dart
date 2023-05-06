import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/pages/preRegistration/widgets/preReg1.dart';
import 'package:pharma_app/src/pages/preRegistration/widgets/preReg2.dart';
import 'package:pharma_app/src/pages/preRegistration/widgets/preReg3.dart';

import 'package:footer/footer.dart';

class PreReg extends ConsumerStatefulWidget {
  const PreReg({super.key});

  @override
  ConsumerState<PreReg> createState() => _PreRegState();
}

class _PreRegState extends ConsumerState<PreReg> {
  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: 500), () => FlutterNativeSplash.remove());
    super.initState();
  }

  var index = 0;
  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
          //   print(index);
        },
        controller: controller,
        children: [
          PreReg1(index),
          PreReg2(index),
          PreReg3(index),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).pushReplacementNamed('PreSignUp');
                },
              );
            },
            child: const Text(
              'Salta',
              style: TextStyle(color: Color.fromARGB(114, 9, 15, 71)),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: () {
              controller.animateToPage(0,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.easeInOut);
            },
            child: index == 0
                ? SvgPicture.asset('assets/ico/dotSelected.svg')
                : SvgPicture.asset('assets/ico/dot.svg'),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              controller.animateToPage(1,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.easeInOut);
            },
            child: index == 1
                ? SvgPicture.asset('assets/ico/dotSelected.svg')
                : SvgPicture.asset('assets/ico/dot.svg'),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              controller.animateToPage(2,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.easeInOut);
            },
            child: index == 2
                ? SvgPicture.asset('assets/ico/dotSelected.svg')
                : SvgPicture.asset('assets/ico/dot.svg'),
          ),
          const SizedBox(
            width: 50,
          ),
          TextButton(
            onPressed: () {
              if (index == 2) {
                //print(controller.position);
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    Navigator.of(context).pushReplacementNamed('PreSignUp');
                  },
                );
              } else if (index == 0) {
                controller.animateToPage(1,
                    duration: Duration(milliseconds: 5),
                    curve: Curves.easeInOut);
              } else if (index == 1) {
                controller.animateToPage(2,
                    duration: Duration(milliseconds: 5),
                    curve: Curves.easeInOut);
              }
            },
            child: const Text(
              'Avanti',
              style: TextStyle(
                  color: Color.fromARGB(255, 47, 161, 148),
                  fontWeight: FontWeight.w900),
            ),
          )
        ],
      ),
    );
  }
}
