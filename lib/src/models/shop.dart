import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../helpers/custom_trace.dart';
import '../models/media.dart';
import 'user.dart';

//here goes the function

@JsonSerializable()
class Shop {
  String? id;
  String? name;
  Media? image;
  String? rate;
  String? address;
  String? description;
  String? phone;
  String? mobile;
  String? information;
  double? deliveryFee;
  double? adminCommission;
  double? defaultTax;
  String? latitude;
  String? longitude;
  bool? closed;
  bool? availableForDelivery;
  double? deliveryRange;
  double? distance;
  List<User> users = [];
  List<String> orario = [];
  String? printOrario;
  double? ordine_minimo;
  int? giorni_consegna;
  bool? accettaPaypal;
  bool? accettaContanti;
  bool? accettaCarta;
  bool? hasMenu;
  bool? hasPrenot;
  String? tempo_consegna;
  List<Media> gallery = [];
  bool isHotel = false;
  bool isService = false;
  String? email;

  final List<String> days = ["dom", "lun", "mar", "mer", "gio", "ven", "sab"];

  Shop();

  Shop.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJson(jsonMap['media'][0])
          : new Media();
      rate = jsonMap['rate'] ?? '0';
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      adminCommission = jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0;
      deliveryRange = jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0;
      address = jsonMap['address'];
      description = jsonMap['description'];
      phone = jsonMap['phone'];
      mobile = jsonMap['mobile'];
      defaultTax = jsonMap['default_tax'] != null
          ? jsonMap['default_tax'].toDouble()
          : 0.0;
      information = jsonMap['information'];
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      closed = jsonMap['closed'] ?? false;
      availableForDelivery = jsonMap['available_for_delivery'] ?? false;
      distance = jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0;
      ordine_minimo = jsonMap['ordine_minimo'] != null
          ? double.parse(jsonMap['ordine_minimo'].toString())
          : 0.0;
      giorni_consegna = jsonMap['giorni_consegna'] != null
          ? int.parse(jsonMap['giorni_consegna'].toString())
          : 2;
      users = jsonMap['users'] != null && (jsonMap['users'] as List).length > 0
          ? List.from(jsonMap['users'])
              .map((element) => User.fromJSON(element))
              .toSet()
              .toList()
          : [];

      tempo_consegna = jsonMap['tempo_consegna'] != null
          ? jsonMap['tempo_consegna'].toString()
          : null;

      if (jsonMap['media'] != null && (jsonMap['media'] as List).length > 1) {
        (jsonMap['media'] as List).forEach((element) {
          gallery.add(Media.fromJson(element));
        });
      }
      orario = [
        "",
        "",
        "",
        "",
        "",
        "",
        "",
      ];
      if (jsonMap['lun_mat_a'] == null &&
          jsonMap['lun_mat_c'] == null &&
          jsonMap['gio_mat_a'] == null &&
          jsonMap['gio_mat_c'] == null &&
          jsonMap['sab_mat_a'] == null &&
          jsonMap['sab_mat_c'] == null &&
          jsonMap['dom_mat_a'] == null &&
          jsonMap['dom_mat_c'] == null) {
        try {
          String? orari_text = jsonMap['orario'];
          if (orari_text != null) {
            DateTime oggi = DateTime.now();
            var orariRaw = orari_text.split("</p>");
            for (String line in orariRaw) {
              line = _parseHtmlString(line);
              if (line.contains("=")) {
                var chunk = line.split("=");
                String key = chunk[0].trim();
                String value = chunk[1].trim();

                if (key.contains("-")) {
                  var lapseDays = key.split("-");
                  int startDay = -1;
                  int endDay = -2;
                  if (days.contains(lapseDays[0].trim())) {
                    startDay = days.indexWhere(
                        (element) => element == key.split("-")[0].trim());
                    endDay = days.indexWhere(
                        (element) => element == key.split("-")[1].trim());
                  } else {
                    DateTime startDate = DateFormat("dd/MM/yyyy")
                        .parse("${lapseDays[0].trim()}/${oggi.year}");
                    DateTime endDate = DateFormat("dd/MM/yyyy")
                        .parse("${lapseDays[1].trim()}/${oggi.year}");
                    if (startDate.difference(oggi) <= Duration(days: 7) &&
                        oggi.isBefore(endDate)) {
                      startDay = startDate.weekday % 7;
                      endDay = endDate.weekday & 7;
                    }
                  }
                  for (int i = startDay; i <= endDay; i++) orario[i] = value;
                } else {
                  if (days.contains(key)) {
                    int day = days.indexWhere((element) => element == key);
                    orario[day] = value;
                  } else {
                    DateTime date =
                        DateFormat("dd/MM/yyyy").parse("$key/${oggi.year}");
                    if (oggi.difference(date) <= Duration(days: 7)) {
                      orario[date.weekday & 7] = value;
                    }
                  }
                }
              }
            }

            var splits = orario[oggi.weekday % 7].trim().split(";");
            if (splits.length > 1) {
              TimeOfDay nowTime = TimeOfDay.now();
              for (String ore in splits) {
                var partiOre = ore.trim().split("-");
                TimeOfDay inizio = TimeOfDay.fromDateTime(
                    DateFormat('HH:mm').parse(partiOre[0].trim()));
                TimeOfDay fine = TimeOfDay.fromDateTime(
                    DateFormat('HH:mm').parse(partiOre[1].trim()));
                double now = toDouble(nowTime);
                double inizioDouble = toDouble(inizio);
                double fineDouble = toDouble(fine);
                if (now >= inizioDouble && now <= fineDouble) {
                  printOrario = ore.trim();
                  closed = false;
                  return;
                } else if (now <= inizioDouble) {
                  printOrario = ore.trim();
                  closed = true;
                  return;
                }
              }
              printOrario = splits[nowTime.hour > 12 ? 1 : 0].trim();
              closed = true;
            } else if (splits[0].length > 1) {
              printOrario = splits[0].trim();
              if (printOrario!.contains("-")) {
                var ore = printOrario!.split("-");
                TimeOfDay nowTime = TimeOfDay.now();
                TimeOfDay inizio = TimeOfDay.fromDateTime(
                    DateFormat('HH:mm').parse(ore[0].trim()));
                TimeOfDay fine = TimeOfDay.fromDateTime(
                    DateFormat('HH:mm').parse(ore[1].trim()));

                if (toDouble(nowTime) >= toDouble(inizio) &&
                    toDouble(nowTime) <= toDouble(fine)) {
                  closed = false;
                } else {
                  closed = true;
                }
              } else {
                closed = true;
              }
            } else {
              printOrario = "chiuso";
              closed = true;
            }
          } else {
            printOrario = null;
            closed = false;
          }
        } catch (e) {
          print("Restaurant: $e");

          printOrario = null;
          closed = false;
        }
      } else {
        orario[1] = "${jsonMap['lun_mat_a']}-${jsonMap['lun_mat_c']}";
        if (jsonMap['lun_pom_a'] != null) {
          orario[1] += ";${jsonMap['lun_pom_a']}-${jsonMap['lun_pom_c']}";
        }
        orario[2] = "${jsonMap['mar_mat_a']}-${jsonMap['mar_mat_c']}";
        if (jsonMap['mar_pom_a'] != null) {
          orario[2] += ";${jsonMap['mar_pom_a']}-${jsonMap['mar_pom_c']}";
        }
        orario[3] = "${jsonMap['mer_mat_a']}-${jsonMap['mer_mat_c']}";
        if (jsonMap['mer_pom_a'] != null) {
          orario[3] += ";${jsonMap['mer_pom_a']}-${jsonMap['mer_pom_c']}";
        }
        orario[4] = "${jsonMap['gio_mat_a']}-${jsonMap['gio_mat_c']}";
        if (jsonMap['gio_pom_a'] != null) {
          orario[4] += ";${jsonMap['gio_pom_a']}-${jsonMap['gio_pom_c']}";
        }
        orario[5] = "${jsonMap['ven_mat_a']}-${jsonMap['ven_mat_c']}";
        if (jsonMap['ven_pom_a'] != null) {
          orario[5] += ";${jsonMap['ven_pom_a']}-${jsonMap['ven_pom_c']}";
        }
        orario[6] = "${jsonMap['sab_mat_a']}-${jsonMap['sab_mat_c']}";
        if (jsonMap['sab_pom_a'] != null) {
          orario[6] += ";${jsonMap['sab_pom_a']}-${jsonMap['sab_pom_c']}";
        }
        orario[0] = "${jsonMap['dom_mat_a']}-${jsonMap['dom_mat_c']}";
        if (jsonMap['dom_pom_a'] != null) {
          orario[0] += ";${jsonMap['dom_pom_a']}-${jsonMap['dom_pom_c']}";
        }
        printOrario = orario[DateTime.now().toLocal().weekday % 7];
        if (printOrario!.startsWith("null")) printOrario = null;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      id = '';
      name = '';
      image = new Media();
      rate = '0';
      deliveryFee = 0.0;
      adminCommission = 0.0;
      deliveryRange = 0.0;
      address = '';
      description = '';
      phone = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      closed = false;
      availableForDelivery = false;
      distance = 0;
      users = [];
      printOrario = "Orari sconosciuti";
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image?.toJson(), // Assuming Media has a toJson method
      'rate': rate,
      'delivery_fee': deliveryFee,
      'admin_commission': adminCommission,
      'delivery_range': deliveryRange,
      'address': address,
      'description': description,
      'phone': phone,
      'mobile': mobile,
      'default_tax': defaultTax,
      'information': information,
      'latitude': latitude,
      'longitude': longitude,
      'closed': closed,
      'available_for_delivery': availableForDelivery,
      'distance': distance,
      'ordine_minimo': ordine_minimo,
      'giorni_consegna': giorni_consegna,
      'users': users
          .map((user) => user.toJson())
          .toList(), // Assuming User has a toJson method
      'tempo_consegna': tempo_consegna,
      'gallery': gallery
          .map((media) => media.toJson())
          .toList(), // Assuming Media has a toJson method
      'isHotel': isHotel,
      'isService': isService,
      'email': email,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }

  Map<String, dynamic> toMemory() {
    return {
      'id': id,
    };
  }

  Map<String, dynamic> toDestination() {
    return {
      'address': address,
      'name': name,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
