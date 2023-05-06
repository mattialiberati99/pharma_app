class DestinationObject {
  String? name;
  String? address;
  double? latitude;
  double? longitude;

  DestinationObject.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      name = jsonMap['name'] ?? "Tempo stimato";
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      latitude = (jsonMap['latitude'] != null ? double.parse(jsonMap['latitude']) : null)!;
      longitude = (jsonMap['longitude'] != null ? double.parse(jsonMap['longitude']) : null)!;
    } catch (e) {
      print("errrroooorrr");
      print(e);
    }
  }
}
