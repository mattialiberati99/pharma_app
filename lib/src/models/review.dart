import 'package:pharma_app/src/models/user.dart';

import '../helpers/custom_trace.dart';
import '../models/shop.dart';
import '../providers/user_provider.dart';
import '../repository/user_repository.dart';
import 'farmaco.dart';
import 'media.dart';

class Review {
  String? id;
  String? review;
  int? rate;
  String? username;
  DateTime? date;
  String? imagePath;
  Media? image;
  Object? object;
  User? user;

  Review();

  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      print(jsonMap);
      id = jsonMap['id'].toString();
      review = jsonMap['review'];
      rate = int.parse(jsonMap['rate'].toString());
      username = jsonMap['username'];
      date = DateTime.tryParse(jsonMap['updated_at'] ?? "");
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJson(jsonMap['media'][0])
          : new Media();
      print(image!.name == null);
      if (jsonMap['food'] != null) {
        object = Farmaco.fromJSON(jsonMap['food']);
      } else if (jsonMap['restaurant'] != null) {
        object = Shop.fromJSON(jsonMap['restaurant']);
      }
      user = jsonMap['user'] != null
          ? User.fromJSON(jsonMap['user'])
          : User.fromJSON({})
        ..name = username;
    } catch (e) {
      id = '';
      review = '';
      rate = 0;
      username = "Utente";
      user = User.fromJSON({})..name = username;
      date = null;
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["username"] = username;
    map["user_id"] = currentUser.value.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map<String, dynamic> ofRestaurantToMap(Shop restaurant) {
    var map = this.toMap();
    map["restaurant_id"] = restaurant.id!;
    return map;
  }

  Map<String, dynamic> ofFarmacoToMap(String foodId) {
    var map = this.toMap();
    map["food_id"] = foodId;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
