import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/models/shop.dart';

import '../../../generated/l10n.dart';
import '../../helpers/app_config.dart';
import '../../helpers/app_config.dart';
import '../../helpers/app_config.dart';
import '../../models/category.dart';
import '../../models/search_result.dart';
import '../../providers/filter_provider.dart';
import '../../providers/shops_provider.dart';
import '../../repository/food_repository.dart';
import '../../repository/restaurant_repository.dart';

class SearchCate extends ConsumerStatefulWidget {
  final ValueChanged? onClickFilter;
  final Function? onSuggestionSelected;
  final String? categoriaId;
  final bool showFilter;
  final bool isExpanded;
  final Function? onSubmitted;
  final Function? onStartSearch;
  String? route;

  SearchCate({
    Key? key,
    this.onClickFilter,
    this.onSuggestionSelected,
    this.categoriaId,
    this.showFilter = true,
    this.isExpanded = false,
    this.onSubmitted,
    this.onStartSearch,
    this.route,
  }) : super(key: key);

  @override
  ConsumerState<SearchCate> createState() => _SearchCateState();
}

class _SearchCateState extends ConsumerState<SearchCate> {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.gray4),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.gray4),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            hintText: widget.isExpanded ? 'Cosa vorresti cercare?' : 'Cerca',
          ),
          autofocus: true,
        ),
        suggestionsBoxVerticalOffset: 20,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: AppColors.primary.withOpacity(0.95),
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
              SearchResult.categories: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  imageUrl: suggestion.type == SearchResult.categories
                      ? (suggestion.data as AppCategory).image?.url ?? ""
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
                      : (suggestion.data as AppCategory).image?.url ?? "",
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
          print("food");
          Navigator.of(context).pushNamed(
            widget.route!,
            arguments: suggestion.data as AppCategory,
          );
        },
      ),
    );
  }

  Future<List<SearchResult>> searchElements(String value) async {
    List<SearchResult> elements = [];
    if (value.length >= 3) {
      var categories = await searchCategories(value,
          filter: ref.read(filterProvider).toQuery());
      //filter: ref.read(filterProvider).toQuery());
      for (AppCategory cat in categories) {
        SearchResult search = SearchResult(
            text: cat.name!,
            id: cat.id!,
            route: 'Categoria',
            type: SearchResult.categories,
            data: cat);
        elements.add(search);
      }
    }
    print(elements.first.id);
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
