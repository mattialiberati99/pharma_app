import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../providers/shops_provider.dart';

class FarmacoCardHorizontal extends ConsumerWidget {
  final Farmaco farmaco;
  const FarmacoCardHorizontal({Key? key, required this.farmaco})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        /*     if (farmaco.farmacia != null) {
          logger.info(farmaco.farmacia!.id);
        } else {
          logger.error('farmaco.farmacia.id NULL');
        }
        logger.info(farmaco.name);
        logger.info(farmaco.category ?? 'null'); */

        Navigator.of(context).pushNamed('Product', arguments: farmaco);
      },
      child: Container(
        width: 172,
        height: 175,
        child: ShadowBox(
          hMargin: 8,
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 140,
                      height: 142,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: farmaco.image!.url!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.5.h),
                            Text(
                              farmaco.name ?? '',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: Color.fromARGB(255, 70, 69, 69),
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              '${farmaco.price!.toStringAsFixed(2)}€',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            /*   Text(
                              Helper.skipHtml(farmaco.description ?? ''),
                              style: context.textTheme.titleSmall?.copyWith(
                                color: Color.fromARGB(255, 9, 15, 71),
                                fontSize: 13,
                              ),
                            ), */
                            // ... (rimanenti elementi rimangono invariati)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
