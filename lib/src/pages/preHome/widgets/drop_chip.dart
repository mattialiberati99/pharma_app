import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../helpers/app_config.dart';
import 'custom_menu_item_painter.dart';

class DropChip extends StatefulWidget {
  const DropChip({
    Key? key,
    required this.onSelected,
    required this.selected,
    this.label,
    required this.iconPath,
    required this.size,
    required this.iconSize,
    this.selectedColor,
    this.unSelectedColor,
    this.hasBorder,
  }) : super(key: key);

  final Function onSelected;
  final bool selected;
  final String? label;
  final String iconPath;
  final double size;
  final double iconSize;

  /// Accept custom color for unSelected item
  final Color? unSelectedColor;

  /// Accept custom color for selected item
  final Color? selectedColor;
  final bool? hasBorder;

  @override
  State<DropChip> createState() => _DropChipState();
}

class _DropChipState extends State<DropChip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: FloatingActionButton(
        onPressed: () {},
        clipBehavior: Clip.none,
        backgroundColor: const Color.fromARGB(255, 25, 229, 165),
        //     color: widget.selected
        //        ? widget.selectedColor ?? context.colorScheme.primary
        //       : widget.unSelectedColor ?? Colors.transparent,
        //   shape:
        //  CustomShape(size: Size(widget.size, (widget.size * 0.9818577648766328).toDouble())),

        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: SvgPicture.network(
            alignment: Alignment.center,
            color: Colors.white,
            widget.iconPath,
            width: 19,
            height: 19,
          ),
        ),
        /*
                if (widget.label != null) ...[
                  Padding(
                      padding: const EdgeInsets.only(top: 6, left: 6.0),
                      child: widget.label != null
                          ? Text(widget.label!,
                              style: context.textTheme.subtitle2?.copyWith(
                                  fontSize: 10, color: AppColors.gray1))
                          : null)                ]*/
      ),
    );
  }
}
