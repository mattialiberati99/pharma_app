import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/shops_provider.dart';

import '../app_assets.dart';
import '../helpers/app_config.dart';
import '../helpers/helper.dart';
import '../models/shop.dart';

class ShopCard extends ConsumerWidget {
  final Shop shop;
  final double? bottomMargin;

  const ShopCard({Key? key, this.bottomMargin, required this.shop})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(currentShopIDProvider.notifier).state = shop.id!;
        Navigator.of(context).pushNamed('Store', arguments: shop);
      },
      child: ShadowBox(
          bottomMargin: bottomMargin ?? 0,
          hMargin: 8,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    SizedBox(
                      width: context.mqw * 0.76,
                      height: 156,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Image.network(
                          shop.image!.url!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 20,
                        bottom: 40,
                        child: Text(
                          shop.name ?? '',
                          style: context.textTheme.subtitle1
                              ?.copyWith(color: Colors.white, fontSize: 20),
                        )),
                    Positioned(
                        left: 20,
                        bottom: 15,
                        child: Text(Helper.skipHtml(shop.description ?? ''),
                            style: context.textTheme.subtitle2
                                ?.copyWith(color: Colors.white))),
                  ],
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.mqw * 0.65),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //TODO leggere stringhe da provider dell'item
                      SvgPicture.asset(shop.availableForDelivery == true
                          ? AppAssets.bike
                          : AppAssets.walking),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                            (shop.deliveryFee != 0.0 &&
                                    shop.availableForDelivery == true)
                                ? shop.deliveryFee!.toEUR()
                                : shop.availableForDelivery == false
                                    ? ''
                                    : 'Gratis',
                            style: context.textTheme.subtitle2?.copyWith(
                                color: AppColors.gray2, fontSize: 12)),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset(AppAssets.time),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text('15-20 min',
                            style: context.textTheme.subtitle2?.copyWith(
                                color: AppColors.gray2, fontSize: 12)),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.star,
                        color: context.colorScheme.primary,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text('4.7',
                            style: context.textTheme.subtitle2?.copyWith(
                                color: AppColors.gray2, fontSize: 12)),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
