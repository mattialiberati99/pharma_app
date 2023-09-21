import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/app_config.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType textInputType;
  final Function(String?)? onSaved;
  final Function validator;
  final String hint;
  final TextStyle? hintStyle;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final String? prefixIconAsset;
  final bool obscureText;
  final Color? fillColor;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final Function? onChanged;
  final Function? onTap;
  final TextStyle? errorStyle;
  final textInputAction;

  // void Function(String)? onChanged,
  // void Function(String?)? onSaved,

  const CustomTextFormField({
    Key? key,
    required this.textInputType,
    this.onSaved,
    required this.validator,
    required this.hint,
    this.hintStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconAsset,
    this.obscureText = false,
    this.fillColor,
    this.controller,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.errorStyle, this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          //border: Border.all(color: validate ? config.Colors().secondColor(1) : config.Colors().secondColor(1)),
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: TextFormField(
          onTap: () => onTap?.call(),
          onChanged: (x) => onChanged?.call(x),
          controller: controller,
          keyboardType: textInputType,
          onSaved: (input) => onSaved?.call(input!),
          validator: (input) => validator(input),
          autovalidateMode: autoValidateMode,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: ExtraTextStyles.normalBlackBold,
          textInputAction: textInputAction??TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? Theme.of(context).colorScheme.surface,
            errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondDarkColor)),
            errorStyle: errorStyle ?? ExtraTextStyles.smallColor(Colors.red),
            contentPadding: const EdgeInsets.all(12),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIconAsset != null
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(prefixIconAsset!, fit: BoxFit.fitHeight),
                    ),
                  )
                : prefixIcon,
            hintText: hint,
            hintStyle: hintStyle ?? ExtraTextStyles.normalBlack,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
      );
}
