import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../elements/SquaredIconButton.dart';
import '../../../helpers/app_config.dart';
import '../../../helpers/helper.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  ChatAppBar(
      {Key? key,
      this.title,
      this.backgroundColor,
      this.backPressed,
      this.canGoBack = true,
      this.hideLogo = false,
      this.actions,
      this.color,
      this.titleWidget})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  final Color? backgroundColor;
  final bool canGoBack;
  final bool hideLogo;
  final Function? backPressed;
  final List<Widget>? actions;
  final Color? color;
  final String? title;
  final Widget? titleWidget;

  @override
  _ChatAppBarState createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //if (hideBackImage != null && hideBackImage == false)
            SvgPicture.asset('assets/img/left_img_bar.svg'),
            // Opacity(
            //   opacity: hideLogo ?? true ? 0.0 : 1,
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 24.0),
            //     child: SvgPicture.asset('assets/img/logo_color.svg'),
            //   ),
            // ),
          ],
        ),
      ),
      actions: widget.actions ?? <Widget>[Container()],
      leadingWidth: 90,
      centerTitle: false,
      leading: Navigator.of(context).canPop() && widget.canGoBack
          ? Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 16.0),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (widget.backPressed != null) {
                      widget.backPressed!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  elevation: 3,
                  backgroundColor: Colors.white,
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.arrow_back_ios,
                        color: AppColors.secondColor),
                  )),
                ),
              ),
            )
          : widget.canGoBack
              ? FloatingActionButton(
                  elevation: 4.0,
                  onPressed: () {
                    if (widget.backPressed != null) {
                      widget.backPressed!();
                    } else {
                      Navigator.of(context).pushReplacementNamed('Pages');
                    }
                  },
                  backgroundColor: Colors.white,
                  child: Container(
                    width: 16,
                    child: Icon(Icons.arrow_back_ios,
                        color: widget.color ?? AppColors.mainBlack),
                  ),
                )
              : Container(),
      iconTheme: IconThemeData(
        color: widget.color ?? Theme.of(context).primaryColor,
      ),
      backgroundColor: widget.backgroundColor ?? Colors.white,
      elevation: 0.0,
      title: widget.titleWidget != null
          ? widget.titleWidget
          : Text(
              widget.title ?? 'Chat',
              style: TextStyle(color: AppColors.primary),
            ),
      /* brightness:
          widget.backgroundColor != null ? Brightness.dark : Brightness.light, */
    );
  }
}
