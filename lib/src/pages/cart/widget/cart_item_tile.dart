import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/cart/widget/quantity_counter_cart.dart';

import '../../../helpers/app_config.dart';
import '../../../models/cart.dart';
import '../../../providers/cart_provider.dart';

class CartItemTile extends ConsumerWidget {
  final Cart cart;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDismiss;

  const CartItemTile({
    Key? key,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (DismissDirection direction) async {
        return showConfirmDialog(context);
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDismiss();
        }
      },
      background: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4.0),
        child: ShadowBox(
          hasShadow: false,
          topLeftRadius: 16,
          topRightRadius: 16,
          bottomLeftRadius: 16,
          bottomRightRadius: 16,
          color: AppColors.primary.withOpacity(0.1),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: context.onSmallScreen ? 2 : 4.0),
        child: ShadowBox(
          topLeftRadius: 16,
          topRightRadius: 16,
          bottomLeftRadius: 16,
          bottomRightRadius: 16,
          color: Colors.white,
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: context.onSmallScreen ? 100 : 120),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox.square(
                          dimension: context.onSmallScreen ? 60 : 75,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                            child: Image.network(
                              cart.product!.image?.url ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cart.product!.name != null
                                    ? Text(
                                        cart.product!.name!,
                                        style: context.textTheme.bodyText1
                                            ?.copyWith(
                                                fontSize: context.onSmallScreen
                                                    ? 14
                                                    : 17,
                                                fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(
                                  height: 2,
                                ),
                                cart.product!.restaurant?.name != null
                                    ? Text(
                                        cart.product!.restaurant!.name!,
                                        style: context.textTheme.subtitle2,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : const SizedBox.shrink(),
                                cart.product!.price != null
                                    ? Text(cart.product!.price!.toEUR(),
                                        style: context.textTheme.bodyText2
                                            ?.copyWith(
                                                fontSize: context.onSmallScreen
                                                    ? 17
                                                    : 20,
                                                color: AppColors.gray1))
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        QuantityCounterCart(
                          productQuantity: cart.quantity ?? 0,
                          onAdd: onAdd,
                          onRemove: onRemove,
                        ),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                    if (cart.extras?.isNotEmpty ?? false)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4.0, left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  cart.extras!.map((e) => e.name).join(', '),
                                  maxLines: context.onSmallScreen ? 1 : 2,
                                  style: context.textTheme.subtitle2?.copyWith(
                                      fontSize: 11, color: AppColors.gray1),
                                )),
                          ],
                        ),
                      ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<bool?> showConfirmDialog(
    BuildContext context, {
    String? title,
    String? subTitle,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title ?? context.loc.dialog_title,
            textAlign: TextAlign.center,
          ),
          content: Text(
            subTitle ?? context.loc.dialog_subtitle,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText ?? context.loc.dialog_delete,
                textAlign: TextAlign.center,
                style: context.textTheme.subtitle2
                    ?.copyWith(color: context.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText ?? context.loc.dialog_cancel,
                  style: context.textTheme.subtitle2
                      ?.copyWith(color: context.colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }
}
