import 'package:flutter/material.dart';

import '../helpers/app_config.dart';


class FlatButton extends StatelessWidget {
  final EdgeInsets? padding;
  final OutlinedBorder? shape;
  final Function() onPressed;
  final Widget child;
  final Color? color;
  const FlatButton(
      {Key? key,
      this.padding,
      this.shape,
      required this.onPressed,
      required this.child,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets?>(
            this.padding ),
        shape: MaterialStateProperty.all<OutlinedBorder?>(
            this.shape),
        backgroundColor: MaterialStateProperty.all<Color?>(
            this.color ),
        overlayColor: MaterialStateProperty.all<Color?>(
            AppColors.secondColor.withOpacity(0.2) ),
      ),
    );
  }
}
