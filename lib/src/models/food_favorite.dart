import 'package:pharma_app/src/models/farmaco.dart';

import '../helpers/custom_trace.dart';
import '../models/extra.dart';

class FarmacoFavorite {
  String? id;
  Farmaco? food;
  List<Extra> extras = [];
  String? userId;

  FarmacoFavorite();

  FarmacoFavorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      food = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
      extras = jsonMap['extras'] != null
          ? List.from(jsonMap['extras'])
              .map((element) => Extra.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      id = '';
      food = Farmaco.fromJSON({});
      extras = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  FarmacoFavorite.fromJSONAndFavorite(
      Map<String, dynamic> jsonMap, FarmacoFavorite favorite) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      food = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
      extras = (jsonMap['extras'] != null
          ? List.from(jsonMap['extras'])
              .map((element) => Extra.fromJSON(element))
              .toList()
          : null)!;
    } catch (e) {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      food = favorite.food;
      extras = favorite.extras;

      //print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["food_id"] = food!.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
