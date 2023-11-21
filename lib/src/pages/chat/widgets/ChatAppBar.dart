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
      ),
      actions: widget.actions ?? <Widget>[Container()],
      leadingWidth: 90,
      centerTitle: false,
      leading: Navigator.of(context).canPop() && widget.canGoBack
          ? Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if (widget.backPressed != null) {
                    widget.backPressed!();
                    
                  } else {
                    Navigator.of(context).pop();
                  }
                },
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
        color: Colors.black,
      ),
      backgroundColor: widget.backgroundColor ?? Colors.white,
      elevation: 0,
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
