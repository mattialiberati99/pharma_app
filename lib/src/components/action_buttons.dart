import 'package:flutter/material.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.firstLabel,
    required this.firstAction,
    this.topPadding,
    this.secondAction,
    this.hasSecond = true,
    this.hasNote,
    this.noteAction,
    this.secondLabel,
  }) : super(key: key);

  final String firstLabel;
  final String? secondLabel;
  final double? topPadding;
  final VoidCallback? firstAction;
  final VoidCallback? secondAction;
  final VoidCallback? noteAction;

  final bool? hasSecond;
  final bool? hasNote;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: topPadding ?? 15,
        ),
        Row(
          children: [
            Expanded(
                child: PrimaryNoSizedButton(
                    hMargin: 35, //TODO margine generalizzabile
                    label: firstLabel, //TODO stringhe
                    labelStyle: context.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                    onPressed: firstAction != null ? firstAction! : () {},
                    height: context.onSmallScreen ? 40 : 55)),
          ],
        ),
        Visibility(
            visible: hasSecond ?? true,
            child: Padding(
              padding: EdgeInsets.all(context.onSmallScreen ? 0 : 8.0),
              child: TextButton(
                  onPressed: secondAction != null ? secondAction! : () {},
                  child: Text(
                    secondLabel ?? context.loc.action_btn_cancel,
                    style: context.textTheme.subtitle2?.copyWith(
                        color: Color(0xFFBDBDBD), fontWeight: FontWeight.w600),
                  )),
            )),
        Visibility(
            visible: hasSecond != null && !hasSecond! ? true : false,
            child: SizedBox(
              height: context.onSmallScreen
                  ? context.mqh * 0.005
                  : context.mqh * 0.025,
            )),
        Visibility(
            visible: hasNote != null && !hasNote! ? false : true,
            child: GestureDetector(
              onTap: noteAction ?? () {},
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: context.onSmallScreen ? 4 : 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.loc.action_free_delivery,
                      style:
                          context.textTheme.bodyText1?.copyWith(fontSize: 14),
                    ),
                    const Icon(Icons.expand_more)
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
