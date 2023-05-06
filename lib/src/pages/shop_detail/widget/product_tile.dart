import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/quantity_counter.dart';
import 'package:pharma_app/src/providers/products_provider.dart';

import '../../../helpers/app_config.dart';
import '../../../models/extra.dart';
import '../../../providers/cart_provider.dart';
import 'product_detail_sheet.dart';

class ProductTile extends ConsumerStatefulWidget {
  final Farmaco product;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductTile({
    Key? key,
    required this.product,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  ConsumerState<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends ConsumerState<ProductTile> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return GestureDetector(
      onTap: () => {
        ref.read(currentProductProvider.notifier).state = widget.product,
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) => ProductDetailSheet(
            product: widget.product,
          ),
        )
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox.square(
                  dimension: 75,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    child: Image.network(
                      widget.product.image!.url!,
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
                        widget.product.name != null
                            ? Text(
                                widget.product.name!,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyText1
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 2,
                        ),
                        widget.product.unit != null
                            ? Text(widget.product.unit!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.subtitle2)
                            : const SizedBox.shrink(),
                        widget.product.price != null
                            ? Text(widget.product.price!.toEUR(),
                                style: context.textTheme.bodyText2?.copyWith(
                                    fontSize: 20, color: AppColors.gray1))
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                QuantityCounter(
                  onAdd: widget.onAdd,
                  onRemove: widget.onRemove,
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            )),
      ),
    );
  }
}
