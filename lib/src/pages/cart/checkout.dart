import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../components/AppButton.dart';
import '../../components/CircularLoadingWidget.dart';

import '../../helpers/app_config.dart';
import '../../helpers/helper.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';

class CheckoutWidget extends ConsumerWidget {
  CheckoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProv = ref.watch(cartProvider);
    final orderProv = ref.watch(ordersProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: CustomAppBar(
      //   title: S.of(context).confirm_order,
      //   leftPressed: () {
      //     cartProv.loading = false;
      //     cartProv.notifyListeners();
      //     Navigator.of(context).pop();
      //   },
      // ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 80),
        children: [
          ListTile(
            title: Text(
              S.current.delivery_address,
              style: ExtraTextStyles.normalGreyWBold,
            ),
            trailing: InkWell(
              child: Icon(
                Icons.edit,
                color: AppColors.mainBlack,
                size: 24,
              ),
              onTap: () {
                cartProv.deliveryAddress = null;
                Navigator.of(context).pop();
                Helper.nextOrderPage(context, cartProv, orderProv);
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 0.4)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: Text(
                      cartProv.deliveryAddress!.description!,
                      style: ExtraTextStyles.bigBlack,
                    ),
                  ),
                  Divider(
                    height: 3,
                    color: AppColors.secondDarkColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0),
                    child: Text(
                      cartProv.deliveryAddress!.address!,
                      style: ExtraTextStyles.normalGreyW,
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              "S.current.payment_mode",
              style: ExtraTextStyles.normalGreyWBold,
            ),
            trailing: InkWell(
              child: Icon(
                Icons.edit,
                color: AppColors.mainBlack,
                size: 24,
              ),
              onTap: () {
                cartProv.paymentMethod = null;
                Navigator.of(context).pop();
                Helper.nextOrderPage(context, cartProv, orderProv);
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 0.4)
                    ]),
                child: cartProv.paymentMethod != null
                    ? CreditCardWidget(
                        cardNumber: cartProv.paymentMethod!.number,
                        expiryDate: cartProv.paymentMethod!.expiration!,
                        cardHolderName:
                            cartProv.paymentMethod!.intestazione.toUpperCase(),
                        cvvCode: cartProv.paymentMethod!.cvc,
                        showBackView: false,
                        height: 170,
                        onCreditCardWidgetChange: (_) {},
                        isHolderNameVisible: true,
                        isChipVisible: true,
                        cardBgColor: AppColors.mainBlack,
                        isSwipeGestureEnabled: false,
                      )
                    : Container(
                        color: AppColors.mainBlack,
                        height: 170,
                      )),
          ),
          ListTile(
            title: Text(
              "S.current.confirm_payment",
              style: ExtraTextStyles.normalGreyWBold,
            ),
            trailing: InkWell(
              child: Icon(
                Icons.question_mark,
                color: AppColors.mainBlack,
                size: 24,
              ),
              onTap: () {
                Navigator.of(context).pushNamed('Help');
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 0.4)
                    ]),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "S.current.subtotal" + ":",
                        style: ExtraTextStyles.normalGreyW,
                      ),
                      trailing: Helper.getPrice(cartProv.total, context,
                          style: ExtraTextStyles.normalBlackBold),
                    ),
                    ListTile(
                      title: Text(
                        "S.current.delivery_fee" + ":",
                        style: ExtraTextStyles.normalGreyW,
                      ),
                      trailing: Helper.getPrice(cartProv.delivery_fee, context,
                          style: ExtraTextStyles.normalBlackBold),
                    ),
                    ListTile(
                      title: Text(
                        "S.current.total" + ":",
                        style: ExtraTextStyles.normalGreyW,
                      ),
                      trailing: Helper.getPrice(
                          cartProv.total + cartProv.delivery_fee, context,
                          style: ExtraTextStyles.normalBlackBold),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: SizedBox(
              width: 200,
              child: cartProv.loading
                  ? InkWell(
                      onTap: () {},
                      child: Container(
                        constraints: const BoxConstraints(
                            maxWidth: 200.0, maxHeight: 55.0, minHeight: 55.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: AppColors.mainBlack,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.6,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 4))
                            ]),
                        child: CircularLoadingWidget(
                            height: 30, color: Colors.white),
                      ),
                    )
                  : AppButton(
                      onPressed: () async {
                        List<Order>? orders =
                            await cartProv.proceedOrder(context);
                        if (orders != null && orders.isNotEmpty) {
                          orderProv.orders.insertAll(0, orders);
                          Navigator.of(context).pushNamed('OrderSuccess');
                        }
                      },
                      isExpanded: true,
                      buttonText: "OK",
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
