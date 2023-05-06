import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/quantity_counter.dart';

import '../../../helpers/app_config.dart';
import '../../../models/extra.dart';
import '../../../providers/cart_provider.dart';

class AdditionTile extends ConsumerStatefulWidget {
  final int indexKey;
  final Extra addition;
  final Function(Extra addition)? onAdd;
  final Function(Extra addition)? onRemove;

  const AdditionTile({
    Key? key,
    required this.indexKey,
    required this.addition,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  @override
  ConsumerState<AdditionTile> createState() => _ProductTileState();
}

class _ProductTileState extends ConsumerState<AdditionTile> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.onSmallScreen ? 55 : 70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.addition.name != null
                      ? Text(widget.addition.name!,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyText1)
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 2,
                  ),
                  widget.addition.price != null
                      ? Text(widget.addition.price!.toEUR(),
                          style: context.textTheme.bodyText2
                              ?.copyWith(fontSize: 15, color: AppColors.gray1))
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            QuantityCounter(
              onAdd: () => widget.onAdd!(widget.addition),
              onRemove: () => widget.onRemove!(widget.addition),
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ));
  }
}
