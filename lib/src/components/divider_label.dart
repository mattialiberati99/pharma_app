import 'package:flutter/material.dart';
import 'package:pharma_app/src/app_theme.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class DividerLabel extends StatelessWidget {
  final String label;

  const DividerLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const Divider(
          height: 27,
          thickness: 1,
        ),
        DecoratedBox(
            decoration: BoxDecoration(color: themeData.scaffoldBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(label,
                  style: context.textTheme.subtitle2
                      ?.copyWith(fontSize: 14, color: const Color(0XFF828282))),
            ))
      ],
    );
  }
}
