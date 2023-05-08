import 'package:flutter/material.dart';

class SomethingWrong extends StatelessWidget {
  final String text;
  final IconData errorIcon;
  final Widget action;
  final dynamic details;

  const SomethingWrong(
      {Key? key,
      required this.text,
      required this.errorIcon,
      required this.action,
      required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Theme.of(context).errorColor.withOpacity(1.0),
                            Theme.of(context).errorColor.withOpacity(0.6),
                          ])),
                  child: Icon(
                    errorIcon,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
                SizedBox(height: 2),
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .merge(TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                SizedBox(height: 2),
                action,
                Expanded(child: Container()),
                Text(
                  details.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .merge(TextStyle(color: Colors.grey)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
