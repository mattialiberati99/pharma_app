import 'package:json_annotation/json_annotation.dart';

import '../helpers/custom_trace.dart';
import '../models/media.dart';
import 'farmaco.dart';
part 'category.g.dart';

@JsonSerializable()
class AppCategory {
  String? id;
  String? name;
  Media? image;
  Media? presentation;
  List<Farmaco>? foods;
  List<String>? otherCategories;

  AppCategory();

  AppCategory.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      var listMedia =
          (jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty)
              ? jsonMap['media'] as List
              : [];
      var imageMedia =
          listMedia.where((element) => element['collection_name'] == 'image');

      image =
          imageMedia.isNotEmpty ? Media.fromJson(imageMedia.first) : Media();

      var presentationMedia = listMedia
          .where((element) => element['collection_name'] == 'presentation');
      presentation = presentationMedia.isNotEmpty
          ? Media.fromJson(presentationMedia.first)
          : Media();
      otherCategories = jsonMap['related_ids'] != null &&
              (jsonMap['related_ids'] as List).length > 0
          ? jsonMap['related_ids']
              .map((e) => e.toString())
              .toList()
              .cast<String>()
          : [];
    } catch (e, stack) {
      id = '';
      name = '';
      image = new Media();
      print(e);
      print(stack);
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.presentation != null) {
      data['presentation'] = this.presentation!.toJson();
    }
    if (this.foods != null) {
      data['foods'] = this.foods!.map((food) => food.toJson()).toList();
    }
    if (this.otherCategories != null) {
      data['otherCategories'] = this.otherCategories;
    }
    return data;
  }
}
