import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/order_status.dart';

import '../../../app_assets.dart';
import '../../../helpers/app_config.dart';
import '../../../models/order.dart';

class OrderStatusTile extends StatefulWidget {
  final Order order;

  const OrderStatusTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderStatusTile> createState() => _OrderStatusTileState();
}

class _OrderStatusTileState extends State<OrderStatusTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DecoratedBox(
          decoration: BoxDecoration(
            //TODO colore bordo
            border: Border.all(color: const Color(0XFFE8E8E8), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: context.mqw * 0.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset(AppAssets.package),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order.id ?? '#'),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(widget.order.dateTime.toString(),
                              style: context.textTheme.subtitle2
                                  ?.copyWith(color: AppColors.gray4)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.order.orderStatus?.status ?? '#',
                    style: context.textTheme.bodyText1
                        ?.copyWith(fontSize: 12, color: Colors.green),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
              ))),
    );
  }
}
