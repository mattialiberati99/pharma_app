import '../helpers/custom_trace.dart';
import 'category.dart';

class Filter {

  List<String> cuisines = [];

  Filter();

  Filter.fromJSON(Map<String, dynamic> jsonMap) {
    try {

      cuisines = jsonMap['cuisines'];
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['cuisines'] = cuisines;
    return map;
  }


  Map<String, dynamic> toQuery({Map<String, dynamic>? oldQuery}) {
    Map<String, dynamic> query = {};
    int numSearch = 0;
    String relation = '';
    if (oldQuery != null) {
      relation = oldQuery['with'] != null ? oldQuery['with'] + '.' : '';
      query['with'] = oldQuery['with'] != null ? oldQuery['with'] : null;
    }

    if (cuisines != null && cuisines.isNotEmpty) {
      query['cuisines[]'] = cuisines.map((element) => element).toList();
    }
    if (oldQuery != null) {
      if (query['search'] != null) {
        query['search'] += ';' + oldQuery['search'];
      } else {
        query['search'] = oldQuery['search'];
      }
      numSearch++;
      if (query['searchFields'] != null) {
        query['searchFields'] = query['searchFields'] + ';' + oldQuery['searchFields'];
      } else {
        query['searchFields'] = oldQuery['searchFields'];
      }

//      query['search'] =
//          oldQuery['search'] != null ? (query['search']) ?? '' + ';' + oldQuery['search'] : query['search'];
//      query['searchFields'] = oldQuery['searchFields'] != null
//          ? query['searchFields'] ?? '' + ';' + oldQuery['searchFields']
//          : query['searchFields'];
    }

    if (numSearch > 1) query['searchJoin'] = 'and';
    return query;
  }
}
