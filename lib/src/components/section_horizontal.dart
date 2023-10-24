import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/section_header.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';
import 'package:pharma_app/src/providers/food_provider.dart';

import '../providers/acquistiRecenti_provider.dart';
import '../providers/shops_provider.dart';
import 'async_value_widget.dart';
import 'shop_card_horizontal.dart';

class SectionHorizontal extends ConsumerStatefulWidget {
  final String title;

  final String subTitle;

  const SectionHorizontal(
      {Key? key, required this.title, required this.subTitle})
      : super(key: key);

  @override
  ConsumerState<SectionHorizontal> createState() => _SectionHorizontalState();
}

class _SectionHorizontalState extends ConsumerState<SectionHorizontal> {
  @override
  void initState() {
    super.initState();
    ref.read(acquistiRecentiProvider).loadData();
  }

  @override
  Widget build(BuildContext context) {
    //final chosen = ref.watch(farmaOfCategoryProvider('11'));
    final acquistiRecentiProv = ref.watch(acquistiRecentiProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 28, 31, 30),
                  fontWeight: FontWeight.w600),
            ),
            Text(
              widget.subTitle,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 28, 31, 30),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),

        //TODO valutare su usare overflow o meno anche per il filtro e se mettere un padding
        // child: OverflowBox(
        //   maxWidth: MediaQuery.of(context).size.width,

        Container(
          height: 250,
          width: 300,
          child: acquistiRecentiProv.acquistiRecenti.isNotEmpty
              ? ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: acquistiRecentiProv.acquistiRecenti.length,
                  itemBuilder: (_, index) {
                    print(index);
                    return FarmacoCardHorizontal(
                      farmaco: acquistiRecentiProv.acquistiRecenti[index],
                    );
                  },
                )
              : const Padding(
                  padding: EdgeInsets.only(left: 70.0),
                  child: Text('Nessun acquisto recente'),
                ),
        ),
      ],
    );
  }
}
