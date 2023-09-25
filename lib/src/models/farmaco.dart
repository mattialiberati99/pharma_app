import 'package:pharma_app/src/models/shop.dart';
import 'package:json_annotation/json_annotation.dart';

import '../helpers/custom_trace.dart';
import '../models/category.dart';
import '../models/extra.dart';
import '../models/extra_group.dart';
import '../models/media.dart';
import '../models/nutrition.dart';
import '../models/review.dart';
import 'coupon.dart';

part 'farmaco.g.dart';

@JsonSerializable()
class Farmaco {
  String? id;
  String? name;
  double? price;
  double? discountPrice;
  double? iva;
  Media? image;
  String? description;
  String? foglietto;
  String? ingredients;
  String? weight;
  String? unit;
  String? packageItemsCount;
  bool? featured;
  bool? deliverable;
  @JsonKey(ignore: true)
  Shop? farmacia;
  @JsonKey(ignore: true)
  AppCategory? category;
  @JsonKey(ignore: true)
  List<Extra> types = []; // exta per i filtri nella pagina di ricerca
/*   List<Extra> sizes = []; // extra per le taglie
  List<Extra> colors = []; // extra per i colori
  List<Extra> mixtures = []; // extra per le miscele, impasti, ecc
  List<Extra> additions = [];  */ // extra per le aggiunte
  @JsonKey(ignore: true)
  List<Extra> extras = []; // per gli ingredienti
  @JsonKey(ignore: true)
  List<ExtraGroup>? extraGroups;
  @JsonKey(ignore: true)
  List<Review> foodReviews = [];
  @JsonKey(ignore: true)
  List<Nutrition> nutritions = [];
  double? rate = 0;
  int? rateCount = 0;
  String? arrivo;
  List<Media>? gallery;

  Farmaco();

  Farmaco.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0
          ? discountPrice
          : jsonMap['price'] != null
              ? jsonMap['price'].toDouble()
              : 0.0;
      iva = jsonMap['vat'] != null ? jsonMap['vat'].toDouble() : 22.0;
      description = jsonMap['description'];
      foglietto = jsonMap['foglietto'];
      ingredients = jsonMap['ingredients'];
      weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      packageItemsCount = jsonMap['package_items_count'].toString();
      featured = jsonMap['featured'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
      farmacia = jsonMap['restaurant'] != null
          ? Shop.fromJSON(jsonMap['restaurant'])
          : Shop.fromJSON({});
      category = jsonMap['category'] != null
          ? AppCategory.fromJSON(jsonMap['category'])
          : AppCategory.fromJSON({});
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();

      if (jsonMap['media'] != null && (jsonMap['media'] as List).length > 1) {
        (jsonMap['media'] as List).forEach((element) {
          if (gallery == null) gallery = [];
          gallery!.add(Media.fromJSON(element));
        });
      }
      if (jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0) {
        (jsonMap['extras'] as List).forEach((element) {
          if (element['extra_group'] != null &&
              element['extra_group']['restaurant_id'] != 0) {
            ExtraGroup extraGroup = ExtraGroup.fromJSON(element['extra_group']);
            if (extraGroups == null) extraGroups = [];
            if (!extraGroups!.contains(extraGroup))
              extraGroups!.add(extraGroup);
          }
          switch (element['extra_group_id']) {
            case 2:
              types.add(Extra.fromJSON(element));
              break;
            /*    case 3:
              sizes.add(Extra.fromJSON(element));
              break;
            case 4:
              colors.add(Extra.fromJSON(element));
              break;
            case 5:
              mixtures.add(Extra.fromJSON(element));
              break;
            case 6:
              additions.add(Extra.fromJSON(element));
              break; */
            default:
              extras.add(Extra.fromJSON(element));
              break;
          }
        });
      }
      ;

      /*extraGroups = jsonMap['extra_groups'] != null && (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups']).map((element) => ExtraGroup.fromJSON(element)).toSet().toList()
          : [];*/
      foodReviews = jsonMap['food_reviews'] != null &&
              (jsonMap['food_reviews'] as List).length > 0
          ? List.from(jsonMap['food_reviews'])
              .map((element) {
                var review = Review.fromJSON(element);
                return review;
              })
              .toSet()
              .toList()
          : [];
      rate = double.tryParse(jsonMap['rate'].toString());
      rateCount = jsonMap['rate_count'];
      nutritions = jsonMap['nutrition'] != null &&
              (jsonMap['nutrition'] as List).length > 0
          ? List.from(jsonMap['nutrition'])
              .map((element) => Nutrition.fromJSON(element))
              .toSet()
              .toList()
          : [];
      arrivo = jsonMap['arrivo'];
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      iva = 22.0;
      description = '';
      foglietto = '';
      weight = '';
      ingredients = '';
      unit = '';
      packageItemsCount = '';
      featured = false;
      deliverable = false;
      farmacia = Shop.fromJSON({});
      category = AppCategory.fromJSON({});
      image = new Media();
      extras = [];
      extraGroups = [];
      foodReviews = [];
      nutritions = [];
      print(e);
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  factory Farmaco.fromJson(Map<String, dynamic> json) =>
      _$FarmacoFromJson(json);

  Map<String, dynamic> toJson() => _$FarmacoToJson(this);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["vat"] = iva;
    map["description"] = description;
    map['foglietto'] = foglietto;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  Coupon applyCoupon(Coupon coupon) {
    if (coupon.code != '') {
      if (coupon.valid == null) {
        coupon.valid = false;
      }
      coupon.discountables.forEach((element) {
        if (coupon.valid == false) {
          if (element.discountableType == "App\\Models\\Farmaco") {
            if (element.discountableId == id) {
              coupon = _couponDiscountPrice(coupon);
            }
          } else if (element.discountableType == "App\\Models\\Restaurant") {
            if (element.discountableId == farmacia?.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          } else if (element.discountableType == "App\\Models\\Category") {
            if (element.discountableId == category?.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          }
        }
      });
    }
    return coupon;
  }

  Coupon _couponDiscountPrice(Coupon coupon) {
    coupon.valid = true;
    discountPrice = price;
    if (coupon.discountType == 'fixed') {
      price = price! - coupon.discount!;
    } else {
      price = price! - (price! * coupon.discount! / 100);
    }
    if (price! < 0) price = 0;
    return coupon;
  }
}
