import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

/// ElevatedButton gray bg and green label with grey border
class PrimaryNoSizedButton extends StatelessWidget {
  /// Contructor requires label and onPressed parameters
  const PrimaryNoSizedButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.height,
      this.hMargin,
      this.labelStyle})
      : super(key: key);

  /// Button action
  final VoidCallback onPressed;

  /// Label visualized on button
  final String label;
  final TextStyle? labelStyle;

  ///Button height
  final double height;

  final double? hMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: hMargin != null
          ? EdgeInsets.symmetric(horizontal: hMargin!)
          : const EdgeInsets.symmetric(horizontal: 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: height,
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                // side: const BorderSide(
                //   width: 2.0,
                //   color: Colors.white,
                // ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: labelStyle ??
                  context.textTheme.bodyText2!.copyWith(
                    fontSize: 15,
                    color: context.colorScheme.onPrimary,
                  ),
            )),
      ),
    );
  }
}
