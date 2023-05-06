import '../helpers/custom_trace.dart';

class PrezzoConsegna {
  String? id;
  double? distanza;
  double? prezzo;

  PrezzoConsegna();

  PrezzoConsegna.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      distanza = jsonMap['distanza'] != null ? jsonMap['distanza'].toDouble() : -1.0;
      prezzo = jsonMap['prezzo'] != null ? jsonMap['prezzo'].toDouble() : -1.0;
    } catch (e) {
      id = '';
      distanza = -1;
      prezzo = -1;
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["distanza"] = distanza;
    map["prezzo"] = prezzo;
    return map;
  }
}
