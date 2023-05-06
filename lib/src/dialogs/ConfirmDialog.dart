import 'package:flutter/material.dart';

import '../helpers/app_config.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Widget? action;

  const ConfirmDialog(
      {Key? key, required this.title, this.description, this.icon, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        image: DecorationImage(
          image: const AssetImage('assets/app_icon/512.png'),
          fit: BoxFit.fitWidth,
          colorFilter: new ColorFilter.mode(
              Colors.grey[300]!.withOpacity(0.9), BlendMode.srcATop),
        ),
        //color: ThemeApp.primaryColor.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20.0,
        ),
        if (description != null)
          Text(description!, ),
        if (description != null)
          SizedBox(
            height: 20.0,
          ),
        if (icon != null)
        Icon(
          icon,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
        action??Container(),
      ]),
    );
  }
}
