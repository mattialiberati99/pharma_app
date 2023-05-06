import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

/// ElevatedButton gray bg and green label with grey border
class PrimaryCircularButton extends StatelessWidget {
  /// Contructor requires label and onPressed parameters
  const PrimaryCircularButton({
    Key? key,
    required this.size,
    this.icon,
    required this.onPressed,
    this.hMargin,
    this.labelStyle,
  }) : super(key: key);

  /// Button action
  final VoidCallback onPressed;

  final TextStyle? labelStyle;

  ///Button height
  final double size;

  /// Button Icon
  final IconData? icon;

  final double? hMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: hMargin != null
          ? EdgeInsets.symmetric(horizontal: hMargin!)
          : const EdgeInsets.symmetric(horizontal: 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: size,
          minHeight: size,
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              elevation: 0,
              shape: const CircleBorder(
                  // side: const BorderSide(
                  //   width: 2.0,
                  //   color: Colors.white,
                  // ),
                  ),
            ),
            onPressed: onPressed,
            child: Icon(
              icon ?? Icons.add,
              color: Colors.white,
              size: 20,
            )),
      ),
    );
  }
}
