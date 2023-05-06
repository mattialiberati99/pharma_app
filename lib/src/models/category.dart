import '../helpers/custom_trace.dart';
import '../models/media.dart';
import 'farmaco.dart';

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

      image = imageMedia.isNotEmpty
          ? Media.fromJSON(imageMedia.first)
          : new Media();

      var presentationMedia = listMedia
          .where((element) => element['collection_name'] == 'presentation');
      presentation = presentationMedia.isNotEmpty
          ? Media.fromJSON(presentationMedia.first)
          : new Media();
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
}
