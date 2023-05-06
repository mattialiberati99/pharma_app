import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class HeaderTitleBack extends StatelessWidget {
  final String title;

  const HeaderTitleBack({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          //TODO aggiungere ai colori
          color: Color(0xff333333),
        ),
        onPressed: () => Navigator.of(context).pop(),
        label: Text(
          title,
          style: context.textTheme.subtitle1?.copyWith(
            color: const Color(0xff333333),
          ),
        ),
      ),
    );
  }
}
