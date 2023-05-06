import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import '../../../helpers/app_config.dart';

class QuantityCounterCart extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  final Color? backgroundColor;
  final int productQuantity;

  // final int quantity;
  final Function onAdd;
  final Function onRemove;

  const QuantityCounterCart({
    Key? key,
    this.height = 30,
    this.width = 90,
    this.color = Colors.black,
    this.backgroundColor,
    required this.onAdd,
    required this.onRemove,
    required this.productQuantity,
    // required this.quantity,
  }) : super(key: key);

  @override
  State<QuantityCounterCart> createState() => _QuantityCounterCartState();
}

class _QuantityCounterCartState extends State<QuantityCounterCart>
    with AutomaticKeepAliveClientMixin<QuantityCounterCart> {
  late int _quantity;

  @override
  void initState() {
    _quantity = widget.productQuantity;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
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
                        _quantity >= 0 ? widget.onRemove() : null
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
                  onPressed: () => {
                        setState(() {
                          _quantity < 100 ? _quantity++ : null;
                        }),
                        widget.onAdd(),
                      },
                  child: const Icon(Icons.add, color: Colors.white, size: 15)),
            ),
          ],
        ));
  }
}
