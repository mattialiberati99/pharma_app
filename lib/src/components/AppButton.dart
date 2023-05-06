import 'package:flutter/material.dart';

import '../helpers/app_config.dart' as config;
import '../helpers/app_config.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final String? secondButtonText;
  final bool hasSeparationBar;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final bool isExpanded;
  final Color color;
  final TextStyle? textStyle;

  AppButton({
    required this.buttonText,
    required this.onPressed,
    this.secondButtonText,
    this.isExpanded=false,
    this.hasSeparationBar=false,
    this.padding=const EdgeInsets.symmetric(horizontal: 30),
    this.color=AppColors.mainBlack,
    this.textStyle,
  });

  List<Widget> singleOrMultiple(){
    List<Widget> children=[Text(
      buttonText,
      style: textStyle??ExtraTextStyles.normalWhite,
    ),];
    if (secondButtonText!=null){
      if (hasSeparationBar)
        children.add(Text("|",style: ExtraTextStyles.bigWhite));
      children.add(Text(
        secondButtonText!,
        style: textStyle??ExtraTextStyles.normalWhite,
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => this.onPressed(),
      child: Container(
        padding: padding,
        constraints: !isExpanded ? const BoxConstraints(
            maxWidth: 200.0, maxHeight: 55.0, minHeight: 55.0) : const BoxConstraints(
            maxHeight: 55.0, minHeight: 55.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: color,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 0.6,
                  blurRadius: 10.0,
                  offset: Offset(0, 4))
            ]),
        child:

        Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: singleOrMultiple(),
        ),

      ),
    );
  }
}
