import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonSocial extends StatelessWidget {
  const ButtonSocial(
      {Key? key,
      required this.logoPath,
      this.width,
      this.height,
      required this.borderColor,
      required this.onTap,
      this.logoSize})
      : super(key: key);
  final String logoPath;
  final double? logoSize;
  final double? width;
  final double? height;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onTap,
        icon: SvgPicture.asset(logoPath,
            width: logoSize ?? 28, height: logoSize ?? 28),
        label: Text('Applke'));
  }
}

/* 
GestureDetector(
      onTap: onTap,
      child: Container(
          width: width ?? 120,
          height: height ?? 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                  color: borderColor,
                  width: 1.5)),
          child: Center(child: SvgPicture.asset(logoPath,width: logoSize ?? 28, height: logoSize ?? 28,))),
    ); */