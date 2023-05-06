import 'package:flutter/material.dart';
import 'package:pharma_app/src/components/shadow_box.dart';

import 'action_buttons.dart';

class FooterActions extends StatelessWidget {
  final String firstLabel;
  final String? secondLabel;

  final VoidCallback? firstAction;
  final VoidCallback? secondAction;
  final VoidCallback? noteAction;

  final bool? hasSecond;
  final bool? hasNote;

  const FooterActions({
    Key? key,
    required this.firstLabel,
    this.firstAction,
    this.hasSecond = true,
    this.hasNote = false,
    this.secondAction,
    this.noteAction,
    this.secondLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      hasShadow: true,
      topLeftRadius: 15,
      topRightRadius: 15,
      bottomLeftRadius: 0,
      bottomRightRadius: 0,
      color: Colors.white,
      child: ActionButtons(
        firstLabel: firstLabel,
        firstAction: firstAction,
        hasSecond: hasSecond,
        hasNote: hasNote,
        secondAction: secondAction,
        secondLabel: secondLabel,
      ),
    );
  }
}
