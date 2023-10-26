import 'package:json_annotation/json_annotation.dart';

import '../helpers/custom_trace.dart';
part 'user.g.dart';

enum UserState { available, away, busy }

@JsonSerializable()
class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? apiToken;
  String? deviceToken;
  String? phone;
  String? address;
  String? bio;
  //Media? image;
  bool created = false;
  bool manager = false;

  // used for indicate if client logged in or not
  bool? auth;
  bool? fattura;
  bool? notif;
  bool? localiz;
  String? userInvitationCode;
  DateTime? verified;

  String? imagePath;

//  String role;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      phone = jsonMap['phone'] ?? '';
      fattura = jsonMap['fattura'];
      localiz = jsonMap['location'];
      notif = jsonMap['notification'];
      print(jsonMap['manager']);
      //image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
      verified = DateTime.tryParse(jsonMap['email_verified_at'] ?? "");

      userInvitationCode = jsonMap['invitation_code'];
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    if (deviceToken != null) map["device_token"] = deviceToken;
    map["phone"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    //map["media"] = image?.toMap();
    map["fattura"] = fattura;
    map["location"] = localiz;
    map["notification"] = notif;
    map["email_verified_at"] = verified.toString();
    return map;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    //map["thumb"] = image?.thumb;
    map["device_token"] = deviceToken;
    map["email_verified_at"] = verified.toString();
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }

  bool profileCompleted() {
    return name != null &&
        name != 'username' &&
        phone != null &&
        phone != '' &&
        phone!.length > 6;
  }
}
