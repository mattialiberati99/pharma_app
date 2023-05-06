import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';

import '../app_assets.dart';
import '../helpers/helper.dart';
import '../models/shop.dart';
import '../providers/shops_provider.dart';

class FarmacoCardHorizontal extends ConsumerWidget {
  final Farmaco farmaco;
  const FarmacoCardHorizontal({Key? key, required this.farmaco}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('Product', arguments: farmaco);
      },
      child: ShadowBox(
          hMargin: 8,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 250,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: Image.network(
                          farmaco.image!.url!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      //TODO leggere stringhe da provider dell'item

                      Positioned(
                          left: 10,
                          bottom: 55,
                          child: Text(
                            farmaco.name ?? '',
                            style: context.textTheme.subtitle1?.copyWith(
                                color: Color.fromARGB(255, 9, 15, 71),
                                fontSize: 13),
                          )),
                      Positioned(
                          left: 10,
                          bottom: 40,
                          child: Text(Helper.skipHtml(farmaco.description ?? ''),
                              style: context.textTheme.subtitle2?.copyWith(
                                  color: Color.fromARGB(255, 9, 15, 71),
                                  fontSize: 13))),

                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /* Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  farmaco.deliveryFee != 0.0
                                      ? shop.deliveryFee!.toEUR()
                                      : 'Gratis',
                                  style: context.textTheme.subtitle2?.copyWith(
                                      color: Color.fromARGB(255, 9, 15, 71),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ), */
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              child: Container(
                                color: Color.fromARGB(255, 255, 192, 0),
                                width: 48,
                                height: 24,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        width: 13,
                                        height: 12,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/immagini_pharma/star.png'),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text('4.7',
                                          style: context.textTheme.subtitle2
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 13)),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
