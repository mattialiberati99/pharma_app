import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.subtitle1?.copyWith(fontSize: 20),
        ),
        GestureDetector(
            child: Text(
          subTitle,
          style: context.textTheme.bodyText1?.copyWith(
              fontWeight: FontWeight.w600, color: context.colorScheme.primary),
        )),
      ],
    );
  }
}
