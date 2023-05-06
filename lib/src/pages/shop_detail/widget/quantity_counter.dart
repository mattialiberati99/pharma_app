import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/shops_provider.dart';
import '../../../helpers/app_config.dart';
import '../../../providers/can_add_provider.dart';
import '../../../providers/cart_provider.dart';

class QuantityCounter extends ConsumerStatefulWidget {
  final double height;
  final double width;
  final Color color;
  final Color? backgroundColor;

  // final int quantity;
  final Function onAdd;
  final Function onRemove;

  const QuantityCounter({
    Key? key,
    this.height = 30,
    this.width = 90,
    this.color = Colors.black,
    this.backgroundColor,
    required this.onAdd,
    required this.onRemove,
    // required this.quantity,
  }) : super(key: key);

  @override
  ConsumerState<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends ConsumerState<QuantityCounter>
    with AutomaticKeepAliveClientMixin<QuantityCounter> {
  int _quantity = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final canAdd = ref.watch(canAddProvider);

    super.build(context);
    return Container(
        padding: EdgeInsets.zero,
        height: widget.height,
        width: widget.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                  //TODO riutilizzare
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    backgroundColor: MaterialStateProperty.all(
                        context.colorScheme.primary.withOpacity(0.1)),
                    minimumSize: MaterialStateProperty.all(Size.square(28)),
                  ),
                  onPressed: () => {
                        setState(() {
                          _quantity > 0 ? _quantity-- : null;
                        }),
                        _quantity > 0 ? widget.onRemove() : null
                      },
                  child: Center(
                      child: Icon(
                    Icons.remove,
                    color: _quantity > 0
                        ? context.colorScheme.primary
                        : AppColors.gray4,
                    size: 15,
                  ))),
            ),
            SizedBox(
              width: widget.width / 3,
              child: Center(
                child: Text(
                  _quantity.toStringAsFixed(0),
                  style: context.textTheme.bodyText2?.copyWith(fontSize: 15),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                  //TODO riutilizzare
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    backgroundColor:
                        MaterialStateProperty.all(context.colorScheme.primary),
                    minimumSize: MaterialStateProperty.all(Size.square(28)),
                  ),
                  onPressed: (_quantity < 100 && canAdd)
                      ? () {
                          setState(() {
                            _quantity++;
                            widget.onAdd();
                          });
                        }
                      : null,
                  // {
                  //   setState(() {
                  //     ( _quantity < 100 && canAdd()) ? _quantity++ : null;
                  //   }),
                  // widget.onAdd()
                  // },
                  child: const Icon(Icons.add, color: Colors.white, size: 15)),
            ),
          ],
        ));
  }
}
