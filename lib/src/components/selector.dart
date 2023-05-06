import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../helpers/app_config.dart';

/// Custom "chip" for content selection
class Selector extends StatelessWidget {
  final bool currentScreen;
  final int index;
  final VoidCallback onTap;

  const Selector({
    Key? key,
    required this.currentScreen,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: currentScreen
                ? context.colorScheme.primary
                : context.colorScheme.primary.withOpacity(0.10)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ProfileSections.values[index].iconPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(ProfileSections.values[index].label,
                textAlign: TextAlign.center,
                style: context.textTheme.subtitle2?.copyWith(
                  color: AppColors.lightBlack1,
                ))
          ],
        )),
      ),
    );
  }
}
