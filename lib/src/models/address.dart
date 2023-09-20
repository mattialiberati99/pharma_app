// ignore_for_file: unnecessary_new

class Address {
  static const defaultLatitude = 40.133333;
  static const defaultLongitude = 15.766667;
  String? id;
  String? description;
  String? address;
  String? phone;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? userId;
  bool? ztl;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : null;
      address = jsonMap['address'];
      phone = jsonMap['phone'];
      latitude = jsonMap['latitude'].toDouble();
      longitude = jsonMap['longitude'].toDouble();
      isDefault = jsonMap['is_default'] ?? false;
      ztl = jsonMap['ztl'] ?? false;
    } catch (e) {
      //print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  bool isUnknown() {
    return latitude == null || longitude == null || id == null || id == 'null';
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["phone"] = phone;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    map["ztl"] = ztl;
    return map;
  }

/*LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }*/
}
