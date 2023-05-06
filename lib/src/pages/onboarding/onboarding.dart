import 'package:flutter/material.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/onboarding/widgets/onboarding_controls.dart';
import 'package:pharma_app/src/pages/onboarding/widgets/onboarding_indicator.dart';

import '../../../generated/l10n.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentStep = 0;

  void onPageChanged(int val) {
    setState(() {
      currentStep = val;
    });
  }

  void onDotTap(int index) {
    _pageController.animateToPage(
      index,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 300),
    );

    setState(() {
      currentStep = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: const [
              DecoratedBox(
                  decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.onboarding1),
                  fit: BoxFit.cover,
                ),
              )),
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.onboarding2),
                    fit: BoxFit.cover,
                  ),
                ),
                //color: Colors.blueGrey,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.onboarding3),
                    fit: BoxFit.cover,
                  ),
                ),
                //color: Colors.blueGrey,
              ),
            ],
          ),
          AnimatedPositioned(
              top: currentStep != 2 ? context.mqh * 0.27 : context.mqh * 0.32,
              duration: const Duration(milliseconds: 300),
              child: OnBoardingIndicator(
                  currentIndex: currentStep, onDotTap: onDotTap)),
          OnboardingControls(currentStep: currentStep),
          Positioned(
            top: context.mqh * 0.10,
            child: AnimatedOpacity(
              opacity: currentStep == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Text(
                    context.loc.onboarding_title_01,
                    style: context.textTheme.headline1
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(context.loc.onboarding_subtitle_01,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headline3
                          ?.copyWith(color: context.colorScheme.onBackground)),
                ],
              ),
            ),
          ),
          Positioned(
            top: context.mqh * 0.10,
            child: AnimatedOpacity(
              opacity: currentStep == 1 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Text(
                    'NON SOLO FOOD',
                    style: context.textTheme.headline1
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('Realizziamo tutti i tuoi \ndesideri dalla A alla Z',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headline3
                          ?.copyWith(color: context.colorScheme.onBackground)),
                ],
              ),
            ),
          ),
          Positioned(
            top: context.mqh * 0.19,
            child: AnimatedOpacity(
              opacity: currentStep == 2 ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Text(
                    'SEMPLICE,',
                    style: context.textTheme.headline1
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('Come dire... TAC!',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headline3
                          ?.copyWith(color: context.colorScheme.onBackground)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
