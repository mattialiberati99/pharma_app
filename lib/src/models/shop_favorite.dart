import 'package:pharma_app/src/models/shop.dart';
import '../helpers/custom_trace.dart';

class ShopFavorite {
  String? id;
  Shop? restaurant;
  String? userId;

  ShopFavorite();

  ShopFavorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      restaurant = jsonMap['restaurant'] != null
          ? Shop.fromJSON(jsonMap['restaurant'])
          : null;
    } catch (e) {
      id = '';
      restaurant = Shop.fromJSON({});
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["restaurant_id"] = restaurant!.id;
    map["user_id"] = userId;
    return map;
  }

  ShopFavorite.fromJSONAndFavorite(jsonMap, ShopFavorite favorite) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      restaurant = favorite.restaurant;
    } catch (e) {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      restaurant = jsonMap['restaurant'] != null
          ? Shop.fromJSON(jsonMap['restaurant'])
          : Shop.fromJSON({});

      //print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }
}
