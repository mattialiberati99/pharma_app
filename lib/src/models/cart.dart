import 'package:pharma_app/src/models/farmaco.dart';

import '../models/extra.dart';
import '../providers/user_provider.dart';
import '../repository/user_repository.dart';
import 'food_order.dart';

class Cart {
  String? id;
  Farmaco? product;
  int? quantity;
  List<Extra>? extras;

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'] : 0;
      product = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
      print(product!.extras.toString());
      extras = jsonMap['extras'] != null
          ? List.from(jsonMap['extras']).map((extra) {
              print(extra['extra_group_id']);
              switch (extra['extra_group_id']) {
                case 2:
                  var extras = product?.types.where((foodExtra) =>
                      foodExtra.id.toString() == extra['id'].toString());
                  return extras!.first;
                // case 3:
                //   var extras = product?.sizes.where((foodExtra) {
                //     return foodExtra.id.toString() == extra['id'].toString();
                //   });
                //   return extras!.first;
                // case 4:
                //   var extras = product?.colors.where((foodExtra) =>
                //       foodExtra.id.toString() == extra['id'].toString());
                //   return extras!.first;
                // case 5:
                //   var extras = product?.mixtures.where((foodExtra) =>
                //       foodExtra.id.toString() == extra['id'].toString());
                //   return extras!.first;
                // case 6:
                //   var extras = product?.additions.where((foodExtra) =>
                //       foodExtra.id.toString() == extra['id'].toString());
                //   return extras!.first;
                default:
                  var extras = product?.extras.where((foodExtra) =>
                      foodExtra.id.toString() == extra['id'].toString());
                  return extras!.first;
              }
            }).toList()
          : [];
    } catch (e, stack) {
      id = '';
      quantity = 0;
      product = Farmaco.fromJSON({});
      extras = [];
      print(e);
      print(stack);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['quantity'] = quantity;
    map['food_id'] = product!.id;
    map['extras'] = extras!.map((element) => element.id).toList();
    map['user_id'] = currentUser.value.id;
    return map;
  }

  double getFarmacoPrice() {
    double result = product!.price!;
    if (extras!.isNotEmpty) {
      extras!.forEach((Extra extra) {
        result += extra.price != null ? extra.price! : 0;
      });
    }
    return result;
  }

  double getFarmacoDiscountPrice() {
    double result = product!.discountPrice!;

    return result;
  }

  bool isSame(Cart cart) {
    bool _same = true;
    _same &= this.product == cart.product;
    _same &= this.extras!.length == cart.extras!.length;
    if (_same) {
      this.extras!.forEach((Extra _extra) {
        _same &= cart.extras!.contains(_extra);
      });
    }
    return _same;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  FarmacoOrder foodOrder() {
    FarmacoOrder _foodOrder = FarmacoOrder();
    _foodOrder.quantity = quantity!;
    _foodOrder.price = getFarmacoPrice();
    _foodOrder.food = product!;
    _foodOrder.extras = extras ?? [];
    return _foodOrder;
  }
}
