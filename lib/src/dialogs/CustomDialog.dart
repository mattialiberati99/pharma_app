import 'dart:ui';

import 'package:flutter/material.dart';

import '../helpers/app_config.dart';
import '../helpers/flat_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final Widget? accept;
  final Widget? cancel;

  const CustomDialog(
      {Key? key,
      required this.title,
      required this.description,
      this.cancel,
      this.accept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(BuildContext context) {
    return Container(
        height: 250,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.only(topRight: Radius.circular(60), bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60)),

          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Color.fromARGB(255, 28, 31, 30),
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              description,
              style: const TextStyle(
                  color: Color.fromARGB(255, 28, 31, 30),
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: AppColors.mainBlack,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: accept ??
                      const Icon(
                        Icons.done,
                        color: AppColors.primary,
                      ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  color: AppColors.mainBlack,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: cancel ??
                      const Icon(
                        Icons.close,
                        color: AppColors.primary,
                      ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
