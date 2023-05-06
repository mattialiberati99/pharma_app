import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../helpers/app_config.dart';
import '../../../helpers/helper.dart';
import '../../../models/shop.dart';
import '../../../providers/shops_provider.dart';

class ShopGridItem extends StatelessWidget {
  final Shop shop;

  const ShopGridItem({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
            width: context.mqw * 0.5,
            top: -2,
            bottom: -50,
            child: Container(
              color: Colors.white,
            )),
        const Positioned(
          top: 0,
          width: 160,
          child: Divider(
            color: AppColors.gray6,
            thickness: 1,
          ),
        ),
        Positioned(
          top: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(14.0),
                ),
                child: Image.network(
                  shop.image!.url!,
                  height: 140,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                child: Text(
                  shop.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyText1
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(Helper.skipHtml(shop.description ?? ''),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ExtraTextStyles.smallGrey),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 0,
          child: Consumer(builder: (context, ref, _) {
            return OutlinedButton(
                //TODO riutilizzare
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  minimumSize: MaterialStateProperty.all(const Size.square(40)),
                  backgroundColor:
                      MaterialStateProperty.all(context.colorScheme.primary),
                ),
                onPressed: () => {
                      ref.read(currentShopIDProvider.notifier).state = shop.id!,
                      Navigator.of(context).pushNamed('Store', arguments: shop)
                    },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xffFFFFFF),
                ));
          }),
        ),
      ],
    );
  }
}
