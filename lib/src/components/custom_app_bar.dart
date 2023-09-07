import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/selected_page_name_provider.dart';

import '../helpers/app_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? leftPressed;
  final Function? openMenu;
  final String? title;
  final bool hideBack;
  final Widget? rightWidget;
  final double elevation;
  final TextStyle? style;
  final Color? backgroundColor;
  final VoidCallback? onPop;

  const CustomAppBar(
      {Key? key,
      this.leftPressed,
      this.openMenu,
      this.title,
      this.hideBack = false,
      this.rightWidget,
      this.elevation = 0,
      this.style,
      this.backgroundColor,
      this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
        elevation: elevation,
        bottomOpacity: 0.0,
        backgroundColor: backgroundColor ?? Colors.white,
        leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: hideBack
                ? Container()
                : GestureDetector(
                    onTap: () => {
                      onPop?.call(),
                      Navigator.of(context).pop(),
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      //TODO aggiungere ai colori
                      color: Color(0xff333333),
                    ),
                  )

            // FloatingActionButton(
            //   onPressed: leftPressed ?? () => Navigator.pop(context),
            //   elevation: 3,
            //   child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Icon(Icons.arrow_back_ios,
            //             color: AppColors.secondColor),
            //       )),
            //   backgroundColor: Colors.white,
            // ),
            ),
        title: title != null
            ? Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.white60, blurRadius: 6.0, spreadRadius: 2.0)
                ]),
                child: Text(title!,
                    textAlign: TextAlign.start,
                    style: context.textTheme.subtitle1?.copyWith(
                      color: const Color(0xff333333),
                    )),
              )
            : Container(),
        actions: [
          if (rightWidget != null) rightWidget!,
        ],
      );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
