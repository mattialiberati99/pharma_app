import 'package:flutter/material.dart';

class ButtonBorderIcon extends StatelessWidget {
  const ButtonBorderIcon(
      {Key? key, required this.icon, this.width, this.height, required this.borderColor, required this.iconColor, required this.onTap})
      : super(key: key);
  final IconData icon;
  final double? width;
  final double? height;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width ?? 46,
          height: height ?? 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                  color: borderColor,
                  width: 1.5)),
          child: Center(child: Icon(icon, size: 22, color: iconColor))),
    );
  }
}
