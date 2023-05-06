import '../helpers/custom_trace.dart';

class ExtraGroup {
  String? id;
  String? name;
  int? min;
  int? max;

  ExtraGroup();

  ExtraGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      min = jsonMap['minExtra'];
      max = jsonMap['maxExtra'];
    } catch (e) {
      id = '';
      name = '';
      min = 0;
      max = 10;
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["minExtra"] = min;
    map["maxExtra"] = max;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
