import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class OnBoardingIndicator extends StatelessWidget {
  /// This holds the index we're at.
  final int currentIndex;

  /// A callback for when the user taps on the dot.
  final Function(int) onDotTap;

  const OnBoardingIndicator(
      {Key? key, required this.currentIndex, required this.onDotTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => _Indicator(
          key: ValueKey('dot-$index'),
          currentScreen: currentIndex == index,
          onTap: () => onDotTap(index),
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool currentScreen;
  final VoidCallback onTap;

  const _Indicator({Key? key, required this.currentScreen, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: currentScreen
              ? context.colorScheme.primary
              : context.colorScheme.onBackground,
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
