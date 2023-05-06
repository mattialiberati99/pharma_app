import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../app_assets.dart';
import '../../../helpers/app_config.dart';

class OrderHistoryTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool? delivered;

  const OrderHistoryTile({
    Key? key,
    this.title,
    this.subtitle,
    this.delivered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray1, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: context.mqw * 0.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SvgPicture.asset(AppAssets.package)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title != null
                              ? Text(title!)
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 2,
                          ),
                          subtitle != null
                              ? Text(subtitle!,
                                  style: context.textTheme.subtitle2?.copyWith(
                                      fontSize: 14,
                                      color: const Color(0XFFBDBDBD)))
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                      child: OutlinedButton(
                          //TODO riutilizzare
                          style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            backgroundColor: MaterialStateProperty.all(
                                context.colorScheme.primary),
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              AppAssets.cart_add,
                            ),
                          ))),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ))),
    );
  }
}
