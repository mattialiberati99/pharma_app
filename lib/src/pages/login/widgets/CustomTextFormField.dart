import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../helpers/app_config.dart' as config;
import '../../../helpers/app_config.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType textInputType;
  final ValueChanged<String>? onSaved;
  final Function validator;
  final String hint;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final String? prefixIconAsset;
  final bool obscureText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Function? onChanged;
  final Function? onTap;
  final TextStyle? errorStyle;
  final textInputAction;

  const CustomTextFormField({
    Key? key,
    required this.textInputType,
    this.onSaved,
    required this.validator,
    required this.hint,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconAsset,
    this.obscureText = false,
    this.controller,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.errorStyle,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray6),
          borderRadius: BorderRadius.circular(24.0),
          color: AppColors.gray7,
        ),
        child: TextFormField(
          onTap: () => onTap?.call(),
          onChanged: (x) => onChanged?.call(x),
          controller: controller,
          keyboardType: textInputType,
          onSaved: (input) => onSaved?.call(input!),
          validator: (input) => validator(input),
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: context.textTheme.subtitle2
              ?.copyWith(color: const Color(0XFF828282)),
          textInputAction: textInputAction ?? TextInputAction.done,
          decoration: InputDecoration(
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondDarkColor)),
            errorStyle: errorStyle ?? ExtraTextStyles.smallColor(Colors.red),
            fillColor: Theme.of(context).primaryColor,
            contentPadding: EdgeInsets.all(12),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIconAsset != null
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Image.asset(prefixIconAsset!, fit: BoxFit.fitHeight),
                    ),
                  )
                : prefixIcon,
            hintText: hint,
            hintStyle: context.textTheme.subtitle2
                ?.copyWith(color: const Color(0XFF828282)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
      );
}
