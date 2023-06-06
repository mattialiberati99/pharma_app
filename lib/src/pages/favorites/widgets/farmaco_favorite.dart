import '../../../helpers/custom_trace.dart';
import '../../../models/farmaco.dart';

class FarmacoFavorite {
  String? id;
  Farmaco? food;
  String? userId;

  FarmacoFavorite();

  FarmacoFavorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      food = jsonMap['food'] != null
          ? Farmaco.fromJSON(jsonMap['food'])
          : Farmaco.fromJSON({});
    } catch (e) {
      id = '';
      food = Farmaco.fromJSON({});
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
    } catch (e) {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      food = favorite.food;

      //print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["food_id"] = food!.id;
    map["user_id"] = userId;
    return map;
  }
}
