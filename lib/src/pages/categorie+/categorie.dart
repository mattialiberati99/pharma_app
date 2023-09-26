import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/category.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';
import 'package:pharma_app/src/providers/favorites_provider.dart';
import 'package:pharma_app/src/providers/food_provider.dart';
import 'package:pharma_app/src/repository/addresses_repository.dart';
import 'dart:math' as math;

import '../../../main.dart';
import '../../components/shadow_box.dart';
import '../../helpers/app_config.dart';
import '../../models/farmaco.dart';
import '../../models/food_favorite.dart';
import '../../repository/favorite_repository.dart';

class Categorie extends ConsumerStatefulWidget {
  final AppCategory nomeCategoria;
  Categorie(this.nomeCategoria);

  @override
  ConsumerState<Categorie> createState() => _CategorieState();
}

class _CategorieState extends ConsumerState<Categorie> {
  var farmaci;

  prodotti(CategoriesProvider categor) async {
    farmaci = categor.getFarmacosOfCategory(widget.nomeCategoria.id!);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.read(cartProvider);
    final categor = ref
        .read(categoriesProvider); //.getFarmaOfCate(widget.nomeCategoria.id!);
    final fav = ref.watch(favoritesProvider);
    final scelti = ref.watch(farmaOfCategoryProvider(widget.nomeCategoria.id!));

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Text(
                  widget.nomeCategoria.name!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('Cart');
                  },
                  child: cart.carts.isNotEmpty
                      ? const Image(
                          image: AssetImage(
                              'assets/immagini_pharma/Icon_shop_noti.png'))
                      : const Image(
                          image: AssetImage(
                              'assets/immagini_pharma/Icon_shop.png')),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  AsyncValueWidget(
                    value: scelti,
                    data: (farma) => Text(
                      '${farma.length} prodotti trovati',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 153, 153, 153)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AsyncValueWidget(
              loading: const CircularProgressIndicator(),
              value: ref.watch(farmaOfCategoryProvider(widget.nomeCategoria
                  .id!)), //categor.categories.values.toList(), data: data)
              data: (farmaciX) {
                //final farmaciOf =
                //       await  categor.getFarmacosOfCategory(widget.nomeCategoria.id!);

                return Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: farmaciX.length,
                          itemBuilder: (context, index) {
                            final scount = ((farmaciX[index].price! -
                                        farmaciX[index].discountPrice!) /
                                    farmaciX[index].price!) *
                                100.toDouble();
                            farmaciX[index].category = widget.nomeCategoria;

                            return FarmacoCategoria(
                              scount: scount,
                              farmaco: farmaciX[index],
                            );
                          })),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class FarmacoCategoria extends ConsumerWidget {
  final Farmaco farmaco;
  final double scount;

  const FarmacoCategoria({
    super.key,
    required this.farmaco,
    required this.scount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final myFarmaco = farmaco;

    FarmacoFavorite? isFavorite = favorites.getFarmacoFavorite(farmaco);
    return GestureDetector(
      onTap: () {
        logger.info(farmaco.category!.name);
        Navigator.of(context).pushNamed('Product', arguments: farmaco);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            SizedBox(
              width: 174,
              height: 276,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(14.0),
                ),
                child: Image.network(
                  farmaco.image!.url!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ShadowBox(
              color: Colors.white,
              topRightRadius: 0,
              topLeftRadius: 0,
              bottomRightRadius: 14,
              bottomLeftRadius: 14,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14.0),
                  bottomRight: Radius.circular(14.0),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  height: context.mqh * 0.1,
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farmaco.name!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 9, 15, 71),
                              fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              child: Container(
                                color: AppColors.primary,
                                width: 48,
                                height: 24,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text('${farmaco.price!}€',
                                          style: context.textTheme.subtitle2
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14)),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: 140,
              top: 20,
              child: GestureDetector(
                onTap: () async {
                  if (isFavorite != null) {
                    if (await removeFarmacoFavorite(isFavorite)) {
                      favorites.delFarmaco(isFavorite);
                    }
                  } else {
                    final favorite = await addFarmacoFavorite(farmaco);
                    if (favorite != null) {
                      favorites.addFarmaco(favorite);
                    }
                  }
                },
                child: Image(
                  image:
                      ref.read(favoritesProvider).getFarmacoFavorite(farmaco) ==
                              null
                          ? const AssetImage('assets/immagini_pharma/Heart.png')
                          : const AssetImage(
                              'assets/immagini_pharma/fullHeart.png'),
                ),
              ),
            ),
            if (scount > 5 && scount != 100)
              Positioned(
                top: 0,
                child: Stack(
                  children: [
                    const Image(
                      image: AssetImage('assets/immagini_pharma/sc.png'),
                    ),
                    Transform.rotate(
                      angle: -math.pi / 4,
                      child: Container(
                        margin: const EdgeInsets.only(top: 15, left: 0),
                        child: Text(
                          "${scount.toInt()}% OFF",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
