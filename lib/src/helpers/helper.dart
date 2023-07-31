import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:global_configuration/global_configuration.dart';

import 'package:html/parser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pharma_app/src/pages/cart/check.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/farmaco.dart';
import '../models/food_order.dart';

import '../models/shop.dart';
import '../pages/payment_cards/gestisci_carte.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/settings_provider.dart';
import 'app_config.dart' as config;
import 'app_config.dart';

class Helper {
  late BuildContext context;
  DateTime? currentBackPressTime;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int?) ?? 0;
  }

  static double getDoubleData(Map<String, dynamic> data) {
    return (data['data'] as double?) ?? 0;
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool?) ?? false;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

//   static Future<Marker> getMarker(Restaurant res, BuildContext context) async {
//     final Marker marker = Marker(
//         markerId: MarkerId(res.id!),
//         icon: await getMarkerIcon(res.image!.url!, Size(MediaQuery.of(context).size.height / 5, MediaQuery.of(context).size.height / 5)),
// //        onTap: () {
// //          //print(res.name);
// //        },
//         anchor: Offset(0.5, 0.5),
//         onTap: () {
//           showDialog(
//               context: context,
//               barrierDismissible: true,
//               builder: (BuildContext context) {
//                 // return object of type Dialog
//                 return MiniRestaurantWidget(
//                   restaurant: res,
//                 );
//               });
//         },
//
//         /*InfoWindow(
//             title: res['name'],
//             snippet: getDistance(
//                 res['distance']?.toDouble()??0.0, setting.value.distanceUnit),
//             onTap: (){
//               if(context!=null)
//               Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantWidget(routeArgument: RouteArgument(param: restaurant),heroTag: 'home_restaurants'+restaurant.id!,)));
//             }),*/
//         position: LatLng(double.parse(res.latitude ?? "0.0"), double.parse(res.longitude ?? "0.0")));
//
//     return marker;
//   }

  // static Future<Marker> getMyPositionMarker(double latitude, double longitude) async {
  //   final Uint8List markerIcon = await getBytesFromAsset('assets/img/my_marker.png', 120);
  //   final Marker marker = Marker(
  //       markerId: MarkerId(Random().nextInt(100).toString()),
  //       icon: BitmapDescriptor.fromBytes(markerIcon),
  //       anchor: Offset(0.5, 0.5),
  //       position: LatLng(latitude, longitude));
  //
  //   return marker;
  // }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static Widget getPrice(double myPrice, BuildContext context,
      {TextStyle? style, String zeroPlaceholder = '-'}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize! + 2));
    }
    try {
      if (myPrice == 0) {
        return Text(zeroPlaceholder,
            style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value.currencyRight != null &&
                setting.value.currencyRight == false
            ? TextSpan(
                text: setting.value.defaultCurrency,
                style: style ?? ExtraTextStyles.bigBlackBold,
                children: <TextSpan>[
                  TextSpan(text: ' '),
                  TextSpan(
                      text: myPrice
                          .toStringAsFixed(setting.value.currencyDecimalDigits),
                      style: style ?? ExtraTextStyles.bigBlackBold),
                ],
              )
            : TextSpan(
                text: myPrice
                    .toStringAsFixed(setting.value.currencyDecimalDigits),
                style: style ?? ExtraTextStyles.bigBlackBold,
                children: <TextSpan>[
                  TextSpan(text: ' '),
                  TextSpan(
                    text: setting.value.defaultCurrency,
                    style: style ?? ExtraTextStyles.bigBlackBold,
                  ),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(FarmacoOrder foodOrder) {
    double total = foodOrder.price!;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price! : 0;
    });
    total *= foodOrder.quantity!;
    return total;
  }

  static double getOrderPrice(FarmacoOrder foodOrder) {
    double total = foodOrder.price!;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price! : 0;
    });
    return total;
  }

  // static double getTotalOrdersPrice(Order order) {
  //   double total = 0;
  //   order.foodOrders.forEach((order) {
  //     total += getTotalOrderPrice(foodOrder);
  //   });
  //   total += order.deliveryFee!;
  //   //total += order.tax!;
  //   total -= order.sconto!;
  //   return total;
  // }

  static String getDistance(double? distance) {
    return distance != null && distance > 0
        ? distance.toStringAsFixed(2) + " km"
        : "";
  }

  static bool canDelivery(Shop _restaurant, {List<Farmaco>? carts}) {
    return true;
    /* bool _can = true;
    String _unit = setting.value.distanceUnit;
    double _deliveryRange = _restaurant.deliveryRange;
    double _distance = _restaurant.distance;
    carts?.forEach((Cart _cart) {
      _can &= _cart.food.deliverable;
    });

    if (_unit == 'km') {
      _deliveryRange /= 1.60934;
    }
    if (_distance == 0 && !deliveryAddress.value.isUnknown()) {
      _distance = sqrt(pow(
              69.1 *
                  (double.parse(_restaurant.latitude) -
                      deliveryAddress.value.latitude),
              2) +
          pow(
              69.1 *
                  (deliveryAddress.value.longitude -
                      double.parse(_restaurant.longitude)) *
                  cos(double.parse(_restaurant.latitude) / 57.3),
              2));
    }
    _can &= _restaurant.availableForDelivery &&
        (_distance < _deliveryRange) &&
        !deliveryAddress.value.isUnknown();
    return _can;*/
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body!.text).documentElement!.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static Html applyHtml(
    context,
    String html,
  ) {
    return Html(
      data: html,
      onLinkTap: (String? url, context, map, element) {
        launchUrlString(url!);
      },
    );
  }

  // static OverlayEntry overlayLoader(context) {
  //   OverlayEntry loader = OverlayEntry(builder: (context) {
  //     final size = MediaQuery.of(context).size;
  //     return Positioned(
  //       height: size.height,
  //       width: size.width,
  //       top: 0,
  //       left: 0,
  //       child: Material(
  //         color: Theme.of(context).backgroundColor.withOpacity(0.55),
  //         child: CircularLoadingWidget(height: 200),
  //       ),
  //     );
  //   });
  //   return loader;
  // }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {}
    });
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getValue('base_url')).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(GlobalConfiguration().getValue('base_url')).scheme,
        host: Uri.parse(GlobalConfiguration().getValue('base_url')).host,
        port: Uri.parse(GlobalConfiguration().getValue('base_url')).port,
        path: _path + path);
    return uri;
  }

  Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF" + hex));
    }
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static AlignmentDirectional getAlignmentDirectional(
      String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  // Future<bool> onWillPop() {
  //   DateTime now = DateTime.now();
  //   if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
  //     currentBackPressTime = now;
  //     Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
  //     return Future.value(false);
  //   }
  //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //   return Future.value(true);
  // }

  // String trans(String text) {
  //   switch (text) {
  //     case "App\\Notifications\\StatusChangedOrder":
  //       return S.of(context).order_status_changed;
  //     case "App\\Notifications\\NewOrder":
  //       return S.of(context).new_order_from_client;
  //     case "App\\Notifications\\ReviewToOrder":
  //       return S.of(context).new_review;
  //     case "App\\Notifications\\DeliveredOrder":
  //       return S.of(context).order_delivered;
  //     case "App\\Notifications\\InDeliveryOrder":
  //       return S.of(context).order_in_delivery;
  //     case "App\\Notifications\\RiderHand":
  //       return S.of(context).order_rider_hand;
  //     case "App\\Notifications\\RiderAlRistorante":
  //       return S.of(context).rider_waiting;
  //     case "App\\Notifications\\UpdatedOrder":
  //       return S.of(context).order_status_changed;
  //     case "km":
  //       return S.of(context).km;
  //     case "mi":
  //       return S.of(context).mi;
  //     default:
  //       return "";
  //   }
  // }

  // static Future<ui.Image> getImage(String path) async {
  //   Completer<ImageInfo> completer = Completer();
  //   var img = new NetworkImage(path);
  //   img.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
  //     completer.complete(info);
  //   }));
  //   ImageInfo imageInfo = await completer.future;
  //   return imageInfo.image;
  // }
  //
  // static Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //
  //   final Radius radius = Radius.circular(size.width / 2);
  //
  //   final Paint shadowPaint = Paint()..color = Colors.deepOrange.withAlpha(100);
  //   final double shadowWidth = 15.0;
  //
  //   final Paint borderPaint = Paint()..color = Colors.white;
  //   final double borderWidth = 3.0;
  //
  //   final double imageOffset = shadowWidth + borderWidth;
  //
  //   // Add shadow circle
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(0.0, 0.0, size.width, size.height),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       shadowPaint);
  //
  //   // Add border circle
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(shadowWidth, shadowWidth, size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       borderPaint);
  //   // Oval for the image
  //   Rect oval = Rect.fromLTWH(imageOffset, imageOffset, size.width - (imageOffset * 2), size.height - (imageOffset * 2));
  //
  //   // Add path for oval image
  //   canvas.clipPath(Path()..addOval(oval));
  //
  //   // Add image
  //   ui.Image image = await getImage(imagePath); // Alternatively use your own method to get the image
  //   paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.cover);
  //
  //   // Convert canvas to image
  //   final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
  //
  //   // Convert image to bytes
  //   final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  //   final Uint8List uint8List = byteData!.buffer.asUint8List();
  //
  //   return BitmapDescriptor.fromBytes(uint8List);
  // }
  //
  // static double getPrezzoConsegna(double distance, Restaurant restaurant) {
  //   var elements = consegna.value.where((element) {
  //     return element.distanza! > distance;
  //   });
  //   return elements.length > 0 ? elements.first.prezzo! : consegna.value.first.prezzo!;
  // }

  static String getNotificationIcon(String type) {
    switch (type) {
      case "App\\Notifications\\StatusChangedOrder":
        return 'assets/img/notif/changed.png';
      case "App\\Notifications\\NewOrder":
        return 'assets/img/notif/new.png';
      case "App\\Notifications\\ReviewToOrder":
        return 'assets/img/notif/review.png';
      case "App\\Notifications\\DeliveredOrder":
        return 'assets/img/notif/delivered.png';
      case "App\\Notifications\\InDeliveryOrder":
        return 'assets/img/notif/in_delivery.png';
      case "App\\Notifications\\RiderHand":
        return 'assets/img/notif/new.png';
      case "App\\Notifications\\RiderAlRistorante":
        return 'assets/img/notif/changed.png';
      case "App\\Notifications\\UpdatedOrder":
        return 'assets/img/notif/changed.png';
      default:
        return "";
    }
  }

  static void nextOrderPage(
      BuildContext context, CartProvider cartProv, OrdersProvider orderProv) {
    if (cartProv.deliveryAddress == null) {
      Navigator.of(context).pushNamed('DeliveryAddresses', arguments: true);
    } else if (cartProv.paymentMethod == null) {
      Navigator.of(context).pushNamed('GestisciCarte', arguments: true);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Conferma'),
              content:
                  Text('Confermare il pagamento con la carta selezionata?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annulla'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      callFinalizeOrder(cartProv, orderProv, context);
                    },
                    child: Text('Paga'))
              ],
            );
          });
      //Navigator.of(context).pushNamed('Check');
    }
  }

  static void callFinalizeOrder(
      CartProvider cartProv, OrdersProvider orderProv, BuildContext context) {
    finalizeOrder(cartProv, orderProv, context);
  }

  //
  // static imgFromCamera(User user) async {
  //   PickedFile? image = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 50);
  //   user.imagePath = image!.path;
  //   return user;
  // }
  //
  // static imgFromGallery(User user) async {
  //   PickedFile? image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);
  //   user.imagePath = image!.path;
  //   return user;
  // }
}
