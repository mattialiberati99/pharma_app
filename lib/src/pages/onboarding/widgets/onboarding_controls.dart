import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../providers/selected_page_name_provider.dart';

/// A widget that displays a navbar for onboarding screens.
class OnboardingControls extends StatelessWidget {
  final int currentStep;

  /// Constructor.
  const OnboardingControls({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AnimatedOpacity(
          opacity: currentStep == 2 ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            visible: currentStep == 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Consumer(builder: (context, ref, _) {
                      return PrimaryNoSizedButton(
                          label: 'INIZIA',
                          height: 45,
                          hMargin: context.mqw * 0.33,
                          onPressed: () => {
                                onSkip(context, ref),
                                ref
                                    .read(selectedPageNameProvider.notifier)
                                    .selectPage(context, 'Login')
                              });
                    })),
              ],
            ),
          ),
        ),
        SizedBox(
          height: context.mqh * 0.14,
        ),
        SizedBox(
          height:
              context.onSmallScreen ? context.mqh * 0.055 : context.mqh * 0.06,
          child: AnimatedOpacity(
            opacity: currentStep != 2 ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Visibility(
              visible: currentStep != 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, _) {
                    return TextButton(
                      onPressed: () => onSkip(context, ref),
                      child: Text(
                        'SKIP',
                        style: context.textTheme.bodyText2!.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onSkip(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pushNamed('Login');
  }
}
