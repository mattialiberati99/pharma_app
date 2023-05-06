import 'package:flutter/material.dart';

/// Wraps the [child] in the default shadow.
class ShadowBox extends StatelessWidget {
  /// The shadow color.
  final Color color;

  ///
  final bool hasShadow;

  final Border? border;
/// Optional external margin useful if placed in listview
  final double? hMargin;
  final double? bottomMargin;

  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  /// The widget that will be wrapped by the shadow.
  final Widget child;

  /// Constructor.
  const ShadowBox({
    Key? key,
    required this.color,
    this.hasShadow = true,
    this.border,
    this.hMargin,
    this.bottomMargin,
    this.topLeftRadius = 10,
    this.topRightRadius = 10,
    this.bottomLeftRadius = 10,
    this.bottomRightRadius = 10,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: hMargin?? 0, right: hMargin?? 0, bottom: bottomMargin?? 0,),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius?? topLeftRadius!),
              topRight: Radius.circular(topRightRadius?? topRightRadius!),
              bottomLeft: Radius.circular(bottomLeftRadius?? bottomLeftRadius!),
              bottomRight: Radius.circular(bottomRightRadius?? bottomRightRadius!)),
          boxShadow: hasShadow
              ? [
                   BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey.withOpacity(0.65),
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
