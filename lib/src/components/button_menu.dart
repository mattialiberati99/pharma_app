import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

///Custom Menu Button with rounded border
class ButtonMenu extends StatelessWidget {
  /// Accepts a background color, transparent if none
  final Color? backgroundColor;

  /// Optional colors for custom effects
  final Color? shadowColor;
  final Color? overlayColor;

  final VoidCallback onPressed;

  const ButtonMenu({
    Key? key,
    this.backgroundColor,
    required this.onPressed,
    this.shadowColor,
    this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size(48, 48)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
        backgroundColor: backgroundColor != null
            ? MaterialStateProperty.all(backgroundColor)
            : MaterialStateProperty.all(Colors.transparent),
        shadowColor: shadowColor != null
            ? MaterialStateProperty.all(shadowColor)
            : MaterialStateProperty.all(Colors.transparent), // <-- Button color
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed))
            return overlayColor ?? Colors.transparent; // <-- Splash color
        }),
      ),
      child: Icon(
        Icons.menu,
        color: context.colorScheme.primary,
      ),
    );
  }
}
