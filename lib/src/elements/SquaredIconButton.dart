import 'package:flutter/material.dart';

import '../helpers/app_config.dart';

class SquaredIconButton extends StatelessWidget{
  final Icon? icon;
  final double? size;
  final Function? onPressed;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final EdgeInsetsGeometry? padding;

  SquaredIconButton({
      this.icon,
      this.size,
      this.onPressed,
      this.backgroundColor,
      this.padding,
      this.splashColor,
      this.borderRadius
  });

  @override
  Widget build(BuildContext context){
    return InkWell(
      splashColor: splashColor,
      onTap: ()=>onPressed!=null?onPressed!():Navigator.pop(context),
      child: Container(
        height: size??40,
        width: size??40,
        decoration: BoxDecoration(
          color: backgroundColor??AppColors.primary.withOpacity(.7),
          borderRadius: borderRadius??BorderRadius.zero,
          boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.5),
            blurRadius: 2,
            ),BoxShadow(color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            ),]
        ),
        child:
          padding!=null?
              Padding(padding: padding!,
              child: icon,):
              Center(child: icon,)
      ),
    );
  }
}