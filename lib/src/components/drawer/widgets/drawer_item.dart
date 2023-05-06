import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

/// Custom Row Item for drawer
class DrawerItem extends ConsumerWidget {
  /// Text for item pageName
  final String pageName;

  /// selectedPageName for active color
  final String? selectedPageName;

  /// SVG path for icon
  final String iconPath;

  /// onPressed action
  final VoidCallback? onPressed;

  const DrawerItem(
      {Key? key,
      this.selectedPageName,
      required this.pageName,
      required this.iconPath,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selectedPageName == pageName;
    //TODO add selected color
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: context.mqw * 0.04),
            child: TextButton.icon(
              style: ButtonStyle(
                textStyle:
                    MaterialStateProperty.all(context.textTheme.headline6),
                foregroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  if (isSelected) return context.colorScheme.primary;
                  if (states.contains(MaterialState.hovered))
                    return context.colorScheme.primary;
                  return Color(0XFF333333);
                }),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                alignment: Alignment.centerLeft,
              ),
              onPressed: onPressed,
              icon: Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: SvgPicture.asset(
                  iconPath,
                  color: isSelected
                      ? context.colorScheme.primary
                      : const Color(0XFF333333),
                ),
              ),
              label: Text(pageName),
            ),
          ),
        ),
      ],
    );
  }
}
