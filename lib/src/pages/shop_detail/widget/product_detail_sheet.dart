import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/components/footer_actions.dart';
import 'package:pharma_app/src/components/same_category_product.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/helpers/helper.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/providers/favorites_provider.dart';
import 'package:pharma_app/src/providers/food_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sizer/sizer.dart';

import 'dart:math' as math;
import '../../../helpers/app_config.dart';
import '../../../models/extra.dart';
import '../../../models/food_favorite.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../repository/favorite_repository.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetailSheet extends ConsumerStatefulWidget {
  final Farmaco product;

  const ProductDetailSheet({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends ConsumerState<ProductDetailSheet> {
  int quantity = 1;

  Extra? types;
  Extra? size;
  Extra? color;
  Extra? mixture;
  Extra? additions;
  List<Extra> extras = [];
  var selected = [];

  @override
  void initState() {
    super.initState();
    if (widget.product.types.isNotEmpty) types = widget.product.types.first;
  }

  final prodottiSimili = [];

  bool desc = false;
  bool foglietto = false;

  @override
  Widget build(BuildContext context) {
    final farmaci = ref.watch(foodProvider(widget.product.restaurant!.id!));
    final favorites = ref.watch(favoritesProvider);
    final cartProv = ref.watch(cartProvider);

    FarmacoFavorite? isFavorite = favorites.getFarmacoFavorite(widget.product);

    final scount = ((widget.product.price! - widget.product.discountPrice!) /
            widget.product.price!) *
        100.toDouble();
    final cart = ref.watch(cartProvider);
    final fav = ref.watch(favoritesProvider);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('Cart'),
                icon: cartProv.carts.isNotEmpty
                    ? Image.asset('assets/immagini_pharma/Icon_shop_noti.png')
                    : Image.asset('assets/immagini_pharma/Icon_shop.png')),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: MediaQuery.of(context).size.height / 6),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        SizedBox(
                          width: context.mqw,
                          height: context.mqh * 0.35,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.product.restaurant!.name!
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              fontSize: 12),
                                        ),
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20)),
                                          child: Container(
                                            color: AppColors.primary,
                                            width: 48,
                                            height: 24,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                      '${widget.product.price!.toStringAsFixed(2)}€',
                                                      style: context
                                                          .textTheme.titleSmall
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.sp)),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      widget.product.name!,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 9, 15, 71),
                                          fontSize: 14),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        if (currentUser.value.apiToken != null)
                          Positioned(
                            left: context.mqw * 0.85,
                            top: 50,
                            child: const Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/points.png'),
                            ),
                          ),
                        if (currentUser.value.apiToken != null)
                          Positioned(
                            left: context.mqw * 0.84,
                            top: 25,
                            child: GestureDetector(
                              onTap: () async {
                                if (isFavorite != null) {
                                  if (await removeFarmacoFavorite(isFavorite)) {
                                    favorites.delFarmaco(isFavorite);
                                  }
                                } else {
                                  final favorite =
                                      await addFarmacoFavorite(widget.product);
                                  if (favorite != null) {
                                    favorites.addFarmaco(favorite);
                                  }
                                }
                              },
                              child: Image(
                                image: fav.getFarmacoFavorite(widget.product) ==
                                        null
                                    ? const AssetImage(
                                        'assets/immagini_pharma/Heart.png')
                                    : const AssetImage(
                                        'assets/immagini_pharma/fullHeart.png'),
                              ),
                            ),
                          ),
                        (scount > 5 && scount != 100)
                            ? Positioned(
                                top: 0,
                                child: Stack(
                                  children: [
                                    const Image(
                                      image: AssetImage(
                                          'assets/immagini_pharma/sc.png'),
                                    ),
                                    Transform.rotate(
                                      angle: -math.pi / 4,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, left: 0),
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
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: const Text(
                        'Descrizione',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        desc
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                      onTap: () => setState(() {
                        desc = !desc;
                      }),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    if (desc)
                      Html(
                        data:
                            widget.product.description ?? 'nessuna desrizione',
                        /*   style: const TextStyle(
                            color: Color.fromARGB(115, 9, 15, 71), fontSize: 12), */
                      ),
                    const Divider(
                      thickness: 2,
                    ),
                    ListTile(
                      title: const Text(
                        'Foglietto illustrativo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        desc
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                      onTap: () => setState(() {
                        foglietto = !foglietto;
                      }),
                    ),
                    if (foglietto)
                      Helper.applyHtml(widget.product.foglietto ??
                          'nessun foglietto illustrativo'),
                    const Divider(
                      thickness: 2,
                    ),
                    const ListTile(
                      title: Text(
                        'Alternative prodotto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SameCategoryProduct(
                      categoryNumber: widget.product.category!.id!,
                      title: '',
                      subTitle: '',
                      excludedProductId: widget.product.id!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: currentUser.value.apiToken == null
            ? const SizedBox()
            : FooterActions(
                firstLabel: 'Aggiungi al carrello',

                firstAction: () {
                  if (size != null) extras.add(size!);
                  if (color != null) extras.add(color!);
                  cart.add(widget.product, quantity, extras);
                  print(widget.product.name);
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Aggiunto",
                      desc: "Prodotto aggiunto correttamente al carrello",
                      btnOkOnPress: () {
                        Navigator.of(context).pushReplacementNamed('Cart');
                      }).show();
                },
                // firstAction: () {
                //   if (size != null) extras.add(size!);
                //   if (color != null) extras.add(color!);
                //   cart.add(widget.product, quantity, extras);
                //   context.navigator.pop();
                //   print(cart.total.toEUR());
                // },
                hasSecond: false,

                hasNote: false,
              ),
        bottomNavigationBar: BottomNavigation(sel: SelectedBottom.home),
      ),
    );
  }
}

class QuantitySetter extends StatefulWidget {
  final int quantity;
  final Function onAdd;
  final Function onRemove;

  const QuantitySetter({
    Key? key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<QuantitySetter> createState() => _QuantitySetterState();
}

class _QuantitySetterState extends State<QuantitySetter> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 154,
        height: 61,
        decoration: ShapeDecoration(
          // TODO colore
          color: AppColors.primary.withOpacity(0.6),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
                //TODO riutilizzare
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size.square(46)),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  backgroundColor:
                      MaterialStateProperty.all(context.colorScheme.onPrimary),
                ),
                onPressed: () => widget.onRemove(),
                child: const Icon(
                  Icons.remove,
                  color: AppColors.solidGrayLight,
                  size: 20,
                )),
            Text(
              widget.quantity.toStringAsFixed(0),
            ),
            OutlinedButton(
                //TODO riutilizzare
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size.square(46)),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  backgroundColor:
                      MaterialStateProperty.all(context.colorScheme.onPrimary),
                ),
                onPressed: () => widget.onAdd(),
                child: const Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 20,
                ))
          ],
        ));
  }
}
