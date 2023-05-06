import 'package:pharma_app/src/models/farmaco.dart';

import '../helpers/custom_trace.dart';
import '../models/extra.dart';

class Favorite {
  String? id;
  Farmaco? farmaco;
  List<Extra> extras = [];
  String? userId;

  Favorite();

  Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      farmaco = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
      extras = jsonMap['extras'] != null
          ? List.from(jsonMap['extras'])
              .map((element) => Extra.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      id = '';
      farmaco = Farmaco.fromJSON({});
      extras = [];
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Favorite.fromJSONAndFavorite(
      Map<String, dynamic> jsonMap, Favorite favorite) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      farmaco = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
      extras = (jsonMap['extras'] != null
          ? List.from(jsonMap['extras'])
              .map((element) => Extra.fromJSON(element))
              .toList()
          : null)!;
    } catch (e) {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      farmaco = favorite.farmaco;
      extras = favorite.extras;

      //print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["food_id"] = farmaco!.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
