import '../helpers/custom_trace.dart';
import 'shop.dart';

class FavoriteRestaurant {
  String? id;
  Shop? restaurant;
  String? userId;

  FavoriteRestaurant();

  FavoriteRestaurant.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      restaurant = jsonMap['restaurants'] != null ? Shop.fromJSON(jsonMap['restaurants']) : null;
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
}
