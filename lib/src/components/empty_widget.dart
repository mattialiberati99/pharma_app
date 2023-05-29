import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/app_config.dart';

class EmptyWidget extends StatefulWidget {
  final String text;
  final String? after;
  final Widget action;
  final IconData icon;
  final IconData? errorIcon;
  final TextStyle? textStyle;

  EmptyWidget(
      {Key? key,
      required this.text,
      required this.action,
      required this.icon,
      this.errorIcon,
      this.after,
      this.textStyle})
      : super(key: key);

  @override
  _EmptyWidgetState createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) setState(() => loading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: loading || widget.errorIcon == null
                              ? [
                                  Colors.white,
                                  Colors.white.withOpacity(0.6),
                                ]
                              : [
                                  Theme.of(context).errorColor.withOpacity(1.0),
                                  Theme.of(context).errorColor.withOpacity(0.6),
                                ])),
                  child: Icon(
                    loading || widget.errorIcon == null
                        ? widget.icon
                        : widget.errorIcon,
                    color: AppColors.primary,
                    size: 60,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Opacity(
                opacity: 0.7,
                child: Text(
                  (loading || widget.after == null
                          ? widget.text
                          : widget.after) ??
                      "",
                  textAlign: TextAlign.center,
                  style: widget.textStyle != null
                      ? widget.textStyle
                      : ExtraTextStyles.mediumSmallBlackBold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              !loading
                  ? widget.action
                  : CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
