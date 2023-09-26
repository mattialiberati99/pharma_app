import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';

import '../helpers/helper.dart';
import '../providers/shops_provider.dart';

class FarmacoCardHorizontal extends ConsumerWidget {
  final Farmaco farmaco;
  const FarmacoCardHorizontal({Key? key, required this.farmaco})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(currentFarmacieShopIDProvider.notifier).state =
            farmaco.farmacia!.id!;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            farmaco.name ?? '',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Color.fromARGB(255, 9, 15, 71),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            Helper.skipHtml(farmaco.description ?? ''),
                            style: context.textTheme.titleSmall?.copyWith(
                              color: Color.fromARGB(255, 9, 15, 71),
                              fontSize: 13,
                            ),
                          ),
                          // ... (rimanenti elementi rimangono invariati)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 8.0,
                right: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
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
                              image:
                                  AssetImage('assets/immagini_pharma/star.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              '4.2',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
