import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../app_assets.dart';
import '../../../components/search_bar/shop_search_bar.dart';
import '../../../helpers/app_config.dart';
import '../../../models/shop.dart';

class ShopHeader extends StatelessWidget {
  final Shop shop;
  const ShopHeader({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            shop.name ?? '',
            style: context.textTheme.overline,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            shop.address ?? '',
            style: context.textTheme.subtitle2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: context.onSmallScreen ? 10 : 20.0,
              bottom: context.onSmallScreen ? 10 : 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //TODO leggere stringhe da provider dell'item
              SvgPicture.asset(AppAssets.bike),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                    shop.deliveryFee != 0.0
                        ? shop.deliveryFee!.toEUR()
                        : 'Gratis',
                    style: context.textTheme.subtitle2
                        ?.copyWith(color: AppColors.gray2, fontSize: 12)),
              ),
              const SizedBox(
                width: 20,
              ),
              const Spacer(),
              SvgPicture.asset(AppAssets.time),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text('15-20 min',
                    style: context.textTheme.subtitle2
                        ?.copyWith(color: AppColors.gray2, fontSize: 12)),
              ),
              const Spacer(),

              Icon(
                Icons.star,
                color: context.colorScheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text('4.7',
                    style: context.textTheme.subtitle2
                        ?.copyWith(color: AppColors.gray2, fontSize: 12)),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SearchBarShop(),
        ),
      ],
    );
  }
}
