import 'package:intl/intl.dart';

import 'discountable.dart';

class Coupon {
  String? id;
  String? code;
  double? discount;
  String? discountType;
  List<Discountable> discountables = [];
  String? discountableId;
  bool? enabled;
  double? ordine_minimo;
  String? message;

  bool? valid;

  Coupon();

  Coupon.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      code = jsonMap['code'] != null ? jsonMap['code'].toString() : '';
      discount = jsonMap['discount'] != null ? jsonMap['discount'].toDouble() : 0.0;
      discountType = jsonMap['discount_type'];
      discountables = jsonMap['discountables'] != null ? List.from(jsonMap['discountables']).map((element) => Discountable.fromJSON(element)).toList() : [];
      ordine_minimo = jsonMap['minimo_ordine'] != null ? jsonMap['minimo_ordine'].toDouble() : 0.0;
      bool enabled = jsonMap['enabled'].toString() == 'true';
      var expires = DateFormat('yyyy-MM-dd kk:mm:ss').parse(jsonMap['expires_at'] ?? '1970-01-01 00:00:00');
      valid = enabled && DateTime.now().isBefore(expires);
    } catch (e) {
      print(e);
      id = '';
      code = '';
      discount = 0.0;
      discountType = '';
      discountables = [];
      valid = null;
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["code"] = code;
    map["discount"] = discount;
    map["discount_type"] = discountType;
    map["valid"] = valid;
    map["discountables"] = discountables.map((element) => element.toMap()).toList();

    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
