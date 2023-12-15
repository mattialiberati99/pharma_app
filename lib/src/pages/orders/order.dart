import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/pages/orders/widgets/ordine_widget.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

import '../../providers/cart_provider.dart';

class OrderP extends ConsumerStatefulWidget {
  const OrderP({super.key});

  @override
  ConsumerState<OrderP> createState() => _OrderPState();
}

class _OrderPState extends ConsumerState<OrderP> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await ref.read(ordersProvider).reloadOrders();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final cartProv = ref.watch(cartProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(sel: SelectedBottom.ordini),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'I miei ordini',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 25, top: 25),
                    child: Text(
                      '${orders.orders.length} articoli ordinati',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(115, 9, 15, 71),
                      ),
                    ),
                  ),
                  if (orders.orders.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: orders.orders.length,
                        itemBuilder: (ctx, i) {
                          return OrdineTab(
                              orders.orders[i].foodOrders[0], orders.orders[i]);
                        },
                      ),
                    ),
                  const SizedBox(),
                ],
              ),
      ),
    );
  }
}
