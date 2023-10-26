import 'dart:ui';

import '../helpers/custom_trace.dart';
import '../models/media.dart';

class Extra {
  String? id;
  String? extraGroupId;
  String? name;
  Color? color;
  double? price;
  Media? image;
  String? description;
  bool? checked;

  Extra();

  Extra.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      extraGroupId = jsonMap['extra_group_id'] != null ? jsonMap['extra_group_id'].toString() : '0';
      name = jsonMap['name'].toString();
      try {
        price = jsonMap['pivot']['price'] != null
            ? jsonMap['pivot']['price'].toDouble()
            : 0;
      }catch(e){
        price=0;
      }
      description = jsonMap['description'];
      color =jsonMap['color']!=null?Color(int.parse(jsonMap['color'].replaceAll("#", "0xFF"))):null;
      checked = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJson(jsonMap['media'][0]) : new Media();
    } catch (e) {
      id = '';
      extraGroupId = '0';
      name = '';
      price = 0.0;
      description = '';
      checked = false;
      image = new Media();
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
