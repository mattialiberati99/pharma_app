import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import 'address.dart';
import 'media.dart';
import 'user.dart';

class Driver {
  String? id;
  User? user;
  double? rating;
  String? distance;
  String? size;
  int? weight;
  String? iban;
  String? fiscalCode;
  int? orderCount;
  double earnings = 0.0;
  bool active = false;
  int? raggio;
  String? frontUrl;
  String? backUrl;
  LatLng? basePosition;

  Driver({
    this.raggio,
    this.weight,
  }
  );

  Driver.fromJSON(jsonMap) {
    try {
      id = jsonMap['id'].toString();

      if(jsonMap['user']!=null)
      user = User.fromJSON(jsonMap['user']);
      rating = jsonMap['rating'];
      orderCount= jsonMap['order_count'];
      earnings = jsonMap['earnings']??0.0;
      active = jsonMap['active']??false;
      iban= jsonMap['iban'];
      fiscalCode = jsonMap['fiscal_code'];
      raggio =jsonMap['raggio'];
      distance = jsonMap['distance'];
      size = jsonMap['max_size'];
      weight = jsonMap['max_weight'];
      frontUrl = jsonMap['front_url'];
      backUrl = jsonMap['back_url'];
      basePosition=LatLng(jsonMap['base_latitude'],jsonMap['base_longitude']);
    } catch (e, stack) {
      logger.error(e);
      logger.error(stack);
    }
  }




  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["iban"] = iban;
    map["fiscal_code"] = fiscalCode;
    map["raggio"] = raggio;
    map['max_size'] = size;
    map['max_weight'] = weight;
    map['earning'] = earnings;
    map['front_url'] = frontUrl;
    map['back_url'] = backUrl;
    map['base_latitude'] = basePosition!.latitude;
    map['base_longitude'] = basePosition!.longitude;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}