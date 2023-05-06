import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../../generated/l10n.dart';
import '../../../helpers/app_config.dart';
import '../../../models/address.dart' as model;
import '../../../models/payment_method.dart';
import '../../../models/shop.dart';

// ignore: must_be_immutable
class DeliveryAddressesItem extends StatelessWidget {
  final model.Address address;
  final PaymentMethod? paymentMethod;
  final Shop? restaurant;
  final ValueChanged<model.Address> onPressed;
  final ValueChanged<model.Address> onLongPress;
  final ValueChanged<model.Address> onDismissed;
  double distance = 0;
  final bool isOrder;
  double price = 0;

  DeliveryAddressesItem(
      {Key? key,
      required this.address,
      required this.onPressed,
      required this.onLongPress,
      required this.onDismissed,
      this.paymentMethod,
      this.restaurant,
      this.isOrder = false})
      : super(key: key) {
    if (restaurant != null) {
      distance = distanceBetween(
              address.latitude ?? double.tryParse(restaurant!.latitude!)!,
              address.longitude ?? double.tryParse(restaurant!.longitude!)!,
              double.tryParse(restaurant!.latitude!)!,
              double.tryParse(restaurant!.longitude!)!) /
          1000;
    }
    price = 0;
    //price=Helper.getPrezzoConsegna(distance);
  }

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static _toRadians(double degree) {
    return degree * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    if (onDismissed != null) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            )),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onDismissed(address);
          }
        },
        child: buildItem(context),
      );
    } else {
      return buildItem(context);
    }
  }

  Opacity buildItem(BuildContext context) {
    return Opacity(
      opacity: distance <= (restaurant?.deliveryRange ?? 1000000) ? 1 : 0.4,
      child: InkWell(
        onTap: () {
          if (distance <= (restaurant?.deliveryRange ?? 10000)) {
            onPressed(address);
          }
        },
        onLongPress: () {
          onLongPress(address);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.gray5.withOpacity(0.5), width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.white,
            /*boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],*/
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: (address.isDefault ?? false) ||
                                (paymentMethod?.selected ?? false)
                            ? AppColors.primary
                            : AppColors.secondColor),
                    child: Icon(
                      (paymentMethod?.selected ?? false)
                          ? Icons.check
                          : Icons.place,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            address.description!.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ExtraTextStyles.normalBlackBold,
                          ),
                          Text(
                            address.address!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: ExtraTextStyles.normalBlack,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*if (isOrder)
                Column(
                  children: [
                    Text(
                      "Consegna",
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                    (address.latitude!=null && address.longitude!=null) ?Helper.getPrice(
                      price,
                      context,
                      style: Theme.of(context).textTheme.bodyText1!,
                    ): Text("Da Calcolare",style: Theme.of(context).textTheme.bodyText1!,)
                  ],
                )*/
            ],
          ),
        ),
      ),
    );
  }
}
