import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/async_value_widget.dart';
import 'package:pharma_app/src/components/footer_actions.dart';
import 'package:pharma_app/src/components/shadow_box.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/shop.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/product_tile.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/shop_bar.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/shop_header.dart';
import 'package:pharma_app/src/providers/can_add_provider.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';

import '../../components/bottomNavigation.dart';
import '../../helpers/app_config.dart';
import '../../models/extra.dart';
import '../../providers/products_provider.dart';

final expandableTextStateProvider1 = StateProvider<bool>((ref) => false);
final expandableTextStateProvider2 = StateProvider<bool>((ref) => false);
final expandableTextStateProvider3 = StateProvider<bool>((ref) => false);

class ShopDetail extends ConsumerStatefulWidget {
  final Shop shop;

  const ShopDetail({Key? key, required this.shop}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShopDetailState();
}

class _ShopDetailState extends ConsumerState<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    bool isExpanded1 = ref.watch(expandableTextStateProvider1);
    bool isExpanded2 = ref.watch(expandableTextStateProvider2);
    bool isExpanded3 = ref.watch(expandableTextStateProvider3);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
        title: const Text('Informazioni Farmacia',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('Cart');
            },
            child: const Image(
                image: AssetImage('assets/immagini_pharma/Icon_shop.png')),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigation(sel: SelectedBottom.chat),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: SingleChildScrollView(
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
                          Radius.circular(14),
                        ),
                        child: Image.network(widget.shop.image!.url!,
                            fit: BoxFit.cover),
                      ),
                    ),
                    ShadowBox(
                      color: Colors.white,
                      topLeftRadius: 0,
                      topRightRadius: 0,
                      bottomLeftRadius: 14,
                      bottomRightRadius: 14,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          height: context.mqh * 0.1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(widget.shop.name!,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 9, 15, 71),
                                          fontSize: 14))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: const Text(
                    'Orari',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    isExpanded1
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                  onTap: () {
                    ref.read(expandableTextStateProvider1.notifier).state =
                        !isExpanded1;
                  },
                ),
                if (isExpanded1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Lunedì: ${widget.shop.orario[0] == 'null-null' ? 'chiuso' : widget.shop.orario[0]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Martedì: ${widget.shop.orario[1] == 'null-null' ? 'chiuso' : widget.shop.orario[1]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Mercoledì: ${widget.shop.orario[2] == 'null-null' ? 'chiuso' : widget.shop.orario[2]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Giovedì: ${widget.shop.orario[3] == 'null-null' ? 'chiuso' : widget.shop.orario[3]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Venerdì: ${widget.shop.orario[4] == 'null-null' ? 'chiuso' : widget.shop.orario[4]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Sabato: ${widget.shop.orario[5] == 'null-null' ? 'chiuso' : widget.shop.orario[5]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Domenica: ${widget.shop.orario[6] == 'null-null' ? 'chiuso' : widget.shop.orario[6]}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ListTile(
                  title: const Text(
                    'Indirizzo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    isExpanded1
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                  onTap: () {
                    ref.read(expandableTextStateProvider2.notifier).state =
                        !isExpanded2;
                  },
                ),
                if (isExpanded2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.shop.address!,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ListTile(
                  title: const Text(
                    'Numero di telefono',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    isExpanded3
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                  onTap: () {
                    ref.read(expandableTextStateProvider3.notifier).state =
                        !isExpanded3;
                  },
                ),
                if (isExpanded3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.shop.phone!,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
