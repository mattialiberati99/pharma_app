import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_toggle.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/orders/widgets/aestetic_widget.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

class OrdinePagato extends ConsumerStatefulWidget {
  const OrdinePagato({super.key});

  @override
  ConsumerState<OrdinePagato> createState() => _OrdinePagatoState();
}

class _OrdinePagatoState extends ConsumerState<OrdinePagato> {
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
                /*for (var i = 0; i < cartProv.carts.length; i++) {
                            try {
                              ordine.food = cartProv.carts[i].product!;
                              ordine.price =
                                  cartProv.carts[i].product!.discountPrice!;
                              ordine.quantity = cartProv.carts[i].quantity!;
                              ordine.dateTime = DateTime.now();
                            } finally {
                              ord.foodOrders.add(ordine);
                            }
                          }
                          ord.active = true;
                       
                          orderProv.add();*/
                //     finalizeOrder(cartProv, orderProv, context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Aestetic()));
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
                      Navigator.of(context).pop();
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
                  'Consegneremo i vostri farmaci al più',
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
                  'presto e in modo sicuro!',
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
          height: 10,
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
                        'Indirizzo e data di consegna: ',
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
                    children: const [
                      Image(
                        image: AssetImage(
                            'assets/immagini_pharma/icon_location.png'),
                        color: Color.fromARGB(255, 167, 166, 165),
                      ),
                      Text(
                        'Indirizzo farmacia',
                        style: TextStyle(
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
                    children: const [
                      Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(255, 167, 166, 165),
                        size: 20,
                      ),
                      Text(
                        'Orario consegna',
                        style: TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pagamento: ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 9, 15, 71),
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          cartProv.sconto.toString() + '€',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 9, 15, 71),
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  )
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
