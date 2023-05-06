class RouteArgument {
  String? id;
  bool showFull;
  dynamic model;

  RouteArgument({this.id, this.showFull=false, this.model});

  @override
  String toString() {
    return '{id: $id, model:${model?.id.toString()}}';
  }
}
