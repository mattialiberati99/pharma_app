import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../components/secondary_circular_button.dart';
import '../../../components/secondary_nosized_button.dart';
import '../../../providers/cart_provider.dart';

class FooterCart extends ConsumerWidget {
  final double deliveryFee;
  final VoidCallback? onAddNote;
  final VoidCallback? onNext;

  const FooterCart({
    Key? key,
    required this.deliveryFee,
    required this.onAddNote,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return ShadowBox(
      hasShadow: true,
      topLeftRadius: 24,
      topRightRadius: 24,
      bottomLeftRadius: 0,
      bottomRightRadius: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.onSmallScreen ? 4 : 8.0, horizontal: 16),
        child: ShadowBox(
          hasShadow: true,
          topLeftRadius: 24,
          topRightRadius: 24,
          bottomLeftRadius: 24,
          bottomRightRadius: 24,
          color: AppColors.primary,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: context.mqh * 0.28,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: context.onSmallScreen ? 4 : 8),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.onSmallScreen ? 0 : 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotale',
                          style: context.textTheme.bodyText1?.copyWith(
                              color: Colors.white,
                              fontSize: context.onSmallScreen ? 14 : 17),
                        ),
                        Text(
                          cart.total.toEUR(decimalDigit: 2),
                          style: context.textTheme.subtitle1?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: context.onSmallScreen ? 17 : 20),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.onSmallScreen ? 0 : 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spese di spedizione',
                          style: context.textTheme.bodyText1?.copyWith(
                              color: Colors.white,
                              fontSize: context.onSmallScreen ? 14 : 17),
                        ),
                        Text(
                          deliveryFee.toEUR(decimalDigit: 2),
                          style: context.textTheme.subtitle1?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: context.onSmallScreen ? 17 : 20),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.onSmallScreen ? 0 : 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sconto',
                          style: context.textTheme.bodyText1?.copyWith(
                              color: Colors.white,
                              fontSize: context.onSmallScreen ? 14 : 17),
                        ),
                        Text(
                          '10%',
                          style: context.textTheme.subtitle1?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: context.onSmallScreen ? 17 : 20),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.gray6,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.onSmallScreen ? 0 : 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Totale',
                          style: context.textTheme.bodyText1?.copyWith(
                              color: Colors.white,
                              fontSize: context.onSmallScreen ? 14 : 17),
                        ),
                        Text(
                          (cart.total + deliveryFee).toEUR(decimalDigit: 2),
                          style: context.textTheme.subtitle1?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: context.onSmallScreen ? 17 : 20),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: context.onSmallScreen ? 4.0 : 8,
                        bottom: context.onSmallScreen ? 0 : 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SecondaryCircularButton(
                            icon: Icons.edit_note,
                            onPressed: onAddNote!,
                            size: context.onSmallScreen ? 40 : 55),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: SecondaryNoSizedButton(
                                label: 'AVANTI',
                                onPressed: onNext!,
                                height: context.onSmallScreen ? 40 : 55))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
