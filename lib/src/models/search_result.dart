class SearchResult {
  static const restaurant = 0;
  static const food = 1;
  static const address = 2;
  static const categories = 2;

  final String? text;
  final String? id;
  final String? route;
  final int? type;
  Object? data;

  SearchResult({this.text, this.id, this.route, this.type, this.data});
}
