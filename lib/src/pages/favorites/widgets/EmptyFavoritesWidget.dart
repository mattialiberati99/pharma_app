import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../models/shop_favorite.dart';
import 'home_popular_restaurant_item_widget.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      'Nessun preferito!',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    )));
  }
}
