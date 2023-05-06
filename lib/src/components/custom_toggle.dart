import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../providers/shops_provider.dart';

class ToggleButton extends ConsumerStatefulWidget {
  const ToggleButton({super.key});

  @override
  ConsumerState<ToggleButton> createState() => _ToggleButtonState();
}

const double width = 87;
const double height = 43;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Color(0XFF333333);
const Color normalColor = Color(0XFF828282);

class _ToggleButtonState extends ConsumerState<ToggleButton> {
  late double xAlign;
  late Color leftColor;
  late Color rightColor;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    leftColor = selectedColor;
    rightColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Color(0XFFE0E0E0),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(xAlign, 0),
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(-1, 1.5),
                        blurRadius: 5,
                        blurStyle: BlurStyle.normal),
                  ],
                  color: context.colorScheme.primary,
                  // Can be circular for round shape
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  xAlign = loginAlign;
                  leftColor = selectedColor;
                  rightColor = normalColor;
                });
                ref.read(deliveryFilterProvider.notifier).state = false;
              },
              child: Align(
                alignment: const Alignment(-1, 0),
                child: Container(
                    width: width * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.walking,
                      color: leftColor,
                    )
                    // Text(
                    //   'Login',
                    //   style: TextStyle(
                    //     color: leftColor,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  xAlign = signInAlign;
                  rightColor = selectedColor;
                  leftColor = normalColor;
                });
                ref.read(deliveryFilterProvider.notifier).state = true;
              },
              child: Align(
                alignment: const Alignment(1, 0),
                child: Container(
                    width: width * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.bike,
                      color: rightColor,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
