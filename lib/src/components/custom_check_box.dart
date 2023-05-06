import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/app_config.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    this.size = _CheckBoxSize.MEDIUM,
    this.type = CheckboxType.basic,
    this.activeBgColor = _CheckBoxColors.ACTIVE_BG,
    this.inactiveBgColor = _CheckBoxColors.UNACTIVE_BG,
    this.activeBorderColor = _CheckBoxColors.UNACTIVE_BG,
    this.inactiveBorderColor = _CheckBoxColors.DARK,
    this.activeBorderWidth = 1,
    required this.onChanged,
    required this.value,
    this.activeIcon = const Icon(
      Icons.check,
      size: 20,
      color: _CheckBoxColors.UNACTIVE_BG,
    ),
    this.inactiveIcon,
    this.customBgColor = _CheckBoxColors.SUCCESS,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  /// type of [CheckboxType] which is of four type is basic, square, circular and custom
  final CheckboxType type;

  /// type of [double] which is GFSize ie, small, medium and large and can use any double value
  final double size;

  /// type of [Color] used to change the backgroundColor of the active checkbox
  final Color activeBgColor;

  /// type of [Color] used to change the backgroundColor of the inactive checkbox
  final Color inactiveBgColor;

  /// type of [Color] used to change the border color of the active checkbox
  final Color activeBorderColor;

  /// type of [Color] used to change the border color of the inactive checkbox
  final Color inactiveBorderColor;

  final double activeBorderWidth;

  /// Called when the user checks or unchecks the checkbox.
  final ValueChanged<bool>? onChanged;

  /// Used to set the current state of the checkbox
  final bool value;

  /// type of [Widget] used to change the  checkbox's active icon
  final Widget? activeIcon;

  /// type of [Widget] used to change the  checkbox's inactive icon
  final Widget? inactiveIcon;

  /// type of [Color] used to change the background color of the custom active checkbox only
  final Color customBgColor;

  /// on true state this widget will be selected as the initial focus
  /// when no other node in its scope is currently focused
  final bool autofocus;

  /// an optional focus node to use as the focus node for this widget.
  final FocusNode? focusNode;

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool get enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: enabled,
        child: InkResponse(
          highlightShape: widget.type == CheckboxType.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          containedInkWell: widget.type != CheckboxType.circle,
          canRequestFocus: enabled,
          onTap: widget.onChanged != null
              ? () {
                  widget.onChanged!(!widget.value);
                }
              : null,
          child: Container(
            height: widget.size,
            width: widget.size,
            margin: widget.type != CheckboxType.circle
                ? const EdgeInsets.all(10)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
                color: enabled
                    ? widget.value
                        ? widget.type == CheckboxType.custom
                            ? Colors.white
                            : widget.activeBgColor
                        : widget.inactiveBgColor
                    : Colors.grey,
                borderRadius: widget.type == CheckboxType.basic
                    ? BorderRadius.circular(3)
                    : widget.type == CheckboxType.circle
                        ? BorderRadius.circular(50)
                        : BorderRadius.zero,
                border: Border.all(
                    width: widget.activeBorderWidth,
                    color: widget.value
                        ? widget.type == CheckboxType.custom
                            ? Colors.black87
                            : widget.activeBorderColor
                        : widget.inactiveBorderColor)),
            child: widget.value
                ? widget.type == CheckboxType.custom
                    ? Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            width: widget.size * 0.8,
                            height: widget.size * 0.8,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: widget.customBgColor),
                          )
                        ],
                      )
                    : widget.activeIcon
                : widget.inactiveIcon,
          ),
        ),
      );
}

/// [_CheckBoxSize] is used to change the size of the widget.
class _CheckBoxSize {
  /// [_CheckBoxSize.SMALL] is used for small size widget
  static const double SMALL = 30;

  /// Default size if [_CheckBoxSize.MEDIUM] is used for medium size widget
  static const double MEDIUM = 35;

  /// [_CheckBoxSize.LARGE] is used for large size widget
  static const double LARGE = 40;
}

enum CheckboxType {
  basic,
  circle,
  square,
  custom,
}

class _CheckBoxColors {
  static const Color ACTIVE_BG = AppColors.primary;
  static const Color SECONDARY = Color(0xffAA66CC);
  static const Color SUCCESS = Color(0xff10DC60);
  static const Color INFO = Color(0xff33B5E5);
  static const Color WARNING = Color(0xffFFBB33);
  static const Color DANGER = Color(0xffF04141);
  static const Color LIGHT = Color(0xffE0E0E0);
  static const Color DARK = Color(0xff222428);
  static const Color UNACTIVE_BG = AppColors.gray6;
  static const Color FOCUS = Color(0xff434054);
  static const Color ALT = Color(0xff794c8a);
  static const Color TRANSPARENT = Colors.transparent;
}
