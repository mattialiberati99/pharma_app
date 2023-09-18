import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/models/shop.dart';

import '../../../generated/l10n.dart';
import '../../helpers/app_config.dart';
import '../../models/search_result.dart';
import '../../pages/medicine/terapie_screen.dart';
import '../../providers/shops_provider.dart';
import '../../repository/food_repository.dart';
import '../../repository/restaurant_repository.dart';

class SearchBarTerapie extends ConsumerStatefulWidget {
  final ValueChanged? onClickFilter;
  final Function? onSuggestionSelected;
  final String? restaurant_id;
  final bool showFilter;
  final bool isExpanded;
  final Function? onSubmitted;
  final Function? onStartSearch;
  final String? routePage;
  final Function(Farmaco) callback;

  const SearchBarTerapie({
    Key? key,
    this.onClickFilter,
    this.onSuggestionSelected,
    this.restaurant_id,
    this.showFilter = true,
    this.isExpanded = false,
    this.onSubmitted,
    this.onStartSearch,
    this.routePage,
    required this.callback,
  }) : super(key: key);

  @override
  ConsumerState<SearchBarTerapie> createState() => _SearchBarTerapieState();
}

class _SearchBarTerapieState extends ConsumerState<SearchBarTerapie> {
  Farmaco? selectedProduct;
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: TypeAheadField(
        textFieldConfiguration: const TextFieldConfiguration(
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray4),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gray4),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              hintText: 'Cerca prodotto',
              suffixIcon: SizedBox(
                  child: Image(
                image: AssetImage('assets/immagini_pharma/barcode.png'),
              )),
              hintStyle: TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
              prefixIcon: Icon(Icons.search),
              prefixIconColor: Color.fromARGB(255, 167, 166, 165)),
          autofocus: false,
        ),
        suggestionsBoxVerticalOffset: 20,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: AppColors.secondColor.withOpacity(0.95),
          constraints: BoxConstraints(minWidth: context.mqw * 0.65),
          offsetX: -15,
        ),
        suggestionsCallback: (pattern) async {
          print("pattern: $pattern");
          return await searchElements(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.all(8),
            leading: case2(suggestion.type, {
              SearchResult.restaurant: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  imageUrl: suggestion.type == SearchResult.restaurant
                      ? (suggestion.data as Shop).image?.url ?? ""
                      : (suggestion.data as Farmaco).image?.url ?? "",
                  placeholder: (context, url) => Image.asset(
                    'assets/immagini/minimal.png',
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SearchResult.food: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  imageUrl: suggestion.type == SearchResult.food
                      ? (suggestion.data as Farmaco).image?.url ?? ""
                      : (suggestion.data as Shop).image?.url ?? "",
                  placeholder: (context, url) => Image.asset(
                    'assets/immagini/loading.gif',
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              //SearchResult.address: Icon(Icons.location_on_outlined)
            }),
            title: Text(suggestion.text ?? ''),
            //subtitle: Text('\$${suggestion['price']}'),
          );
        },
        noItemsFoundBuilder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            "Nessun risultato",
            style: TextStyle(color: Colors.white),
          ),
        ),
        onSuggestionSelected: (suggestion) {
          setState(() {
            selectedProduct = suggestion.data as Farmaco;
          });
          widget.callback(selectedProduct!);
        },
      ),
    );
  }

  Future<List<SearchResult>> searchElements(String value) async {
    List<SearchResult> elements = [];
    if (value.length >= 3) {
      var products =
          await searchFarmacos(value, restaurant_id: widget.restaurant_id);
      for (Farmaco product in products) {
        print(product);
        SearchResult search = SearchResult(
            text: product.name!,
            id: product.id!,
            route: 'SearchBarTerapie',
            type: SearchResult.food,
            data: product);
        elements.add(search);
      }
    }
    return elements;
  }

  TValue? case2<TOptionType, TValue>(
    TOptionType selectedOption,
    Map<TOptionType, TValue> branches, [
    TValue? defaultValue = null,
  ]) {
    if (!branches.containsKey(selectedOption)) {
      return defaultValue;
    }
    return branches[selectedOption];
  }
}
