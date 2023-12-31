import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_toggle.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

import '../../../models/shop.dart';

class OrdineConfermato extends ConsumerStatefulWidget {
  String timeinput;
  Shop restaurant;

  OrdineConfermato(this.timeinput, this.restaurant);

  @override
  ConsumerState<OrdineConfermato> createState() => _OrdineConfermatoState();
}

class _OrdineConfermatoState extends ConsumerState<OrdineConfermato> {
  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);

    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(165, 50),
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)))),
              child: const Text(
                'Torna alla Home',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('Home');
              },
            ),
          ],
        ),
      ),
      body: Column(children: [
        Container(
          height: context.mqh * 0.45,
          padding: EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              color: AppColors.primary),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('Home');
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 15,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 51,
                  width: 51,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white,
                  ),
                  child: const Image(
                      image:
                          AssetImage('assets/immagini_pharma/logo_small.png')),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Grazie!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(image: AssetImage('assets/immagini_pharma/done.png')),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'La tua prenotazione è avvenuta',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'con successo!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: cartProv.carts.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Column(children: [
                Row(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                        color: const Color.fromARGB(255, 242, 243, 243),
                        child: Image(
                          width: 77,
                          height: 88,
                          image: NetworkImage(
                              cartProv.carts[index].product!.image!.url!),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              cartProv.carts[index].product!.name.toString(),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 9, 15, 71),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(children: [
                          Text(
                            '${cartProv.carts[index].product!.discountPrice! * cartProv.carts[index].quantity!}€',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 9, 15, 71),
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
                if (index == cartProv.carts.length - 1)
                  const SizedBox(
                    height: 30,
                  ),
                if (index == cartProv.carts.length - 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Prenotazione',
                        style: TextStyle(
                            color: Color.fromARGB(255, 9, 15, 71),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                if (index == cartProv.carts.length - 1)
                  const SizedBox(
                    height: 15,
                  ),
                if (index == cartProv.carts.length - 1)
                  Row(
                    children: [
                      const Image(
                        image: AssetImage(
                            'assets/immagini_pharma/icon_location.png'),
                        color: Color.fromARGB(255, 167, 166, 165),
                      ),
                      Text(
                        widget.restaurant.address!,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 167, 166, 165),
                        ),
                      )
                    ],
                  ),
                if (index == cartProv.carts.length - 1)
                  const SizedBox(
                    height: 20,
                  ),
                if (index == cartProv.carts.length - 1)
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(255, 167, 166, 165),
                        size: 20,
                      ),
                      Text(
                        widget.timeinput,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 167, 166, 165),
                        ),
                      )
                    ],
                  )
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
