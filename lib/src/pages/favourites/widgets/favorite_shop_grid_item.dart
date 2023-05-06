import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/shop_favorite.dart';

import '../../../helpers/app_config.dart';
import '../../../helpers/helper.dart';
import '../../../providers/shops_provider.dart';

class FavoriteShopGridItem extends ConsumerWidget {
  final ShopFavorite favorite;
  final VoidCallback? onPressed;

  const FavoriteShopGridItem({Key? key, this.onPressed, required this.favorite})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
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
          width: 160,
          child: GestureDetector(
            onTap: () => {
              ref.read(currentShopIDProvider.notifier).state =
                  favorite.restaurant!.id!,
              Navigator.of(context)
                  .pushNamed('Store', arguments: favorite.restaurant)
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                  child: Image.network(
                    favorite.restaurant!.image!.url!,
                    height: 140,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    favorite.restaurant!.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyText1
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(Helper.skipHtml(favorite.restaurant!.description ?? ''),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ExtraTextStyles.smallGrey),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: -8,
          child: IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.favorite, color: AppColors.primary)),
        ),
      ],
    );
  }
}
