import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/models/shop.dart';

import '../../../generated/l10n.dart';
import '../../helpers/app_config.dart';
import '../../models/address.dart';
import '../../models/search_result.dart';
import '../../providers/shops_provider.dart';
import '../../repository/addresses_repository.dart';
import '../../repository/food_repository.dart';
import '../../repository/restaurant_repository.dart';

class SearchBarPreHome extends ConsumerStatefulWidget {
  final ValueChanged? onClickFilter;
  final Function? onSuggestionSelected;
  final String? restaurant_id;
  final bool showFilter;
  final bool isExpanded;
  final Function? onSubmitted;
  final Function? onStartSearch;

  const SearchBarPreHome({
    Key? key,
    this.onClickFilter,
    this.onSuggestionSelected,
    this.restaurant_id,
    this.showFilter = true,
    this.isExpanded = false,
    this.onSubmitted,
    this.onStartSearch,
  }) : super(key: key);

  @override
  ConsumerState<SearchBarPreHome> createState() => _SearchBarPreHomeState();
}

class _SearchBarPreHomeState extends ConsumerState<SearchBarPreHome> {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration.collapsed(
            hintText: widget.isExpanded ? 'Cosa vorresti cercare?' : 'Cerca',
          ),
          autofocus: false,
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
            leading: suggestion.type == SearchResult.restaurant
                ? ClipRRect(
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
                  )
                : suggestion.type == SearchResult.food
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          imageUrl: suggestion.type == SearchResult.food
                              ? (suggestion.data as Farmaco).image?.url ?? ""
                              : (suggestion.data as Shop).image?.url ?? "",
                          placeholder: (context, url) => Image.asset(
                            'assets/immagini/minimal.png',
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )
                    : suggestion.type == SearchResult.address
                        ? Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 40,
                          )
                        : SizedBox(),

            // leading: case2(suggestion.type, {
            //   SearchResult.restaurant: ClipRRect(
            //     borderRadius: BorderRadius.circular(8.0),
            //     child: CachedNetworkImage(
            //       height: 40,
            //       width: 40,
            //       fit: BoxFit.cover,
            //       imageUrl: suggestion.type == SearchResult.restaurant
            //           ? (suggestion.data as Shop).image?.url ?? ""
            //           : (suggestion.data as Farmaco).image?.url ?? "",
            //       placeholder: (context, url) => Image.asset(
            //         'assets/immagini/minimal.png',
            //         fit: BoxFit.cover,
            //         height: 40,
            //         width: 40,
            //       ),
            //       errorWidget: (context, url, error) => Icon(Icons.error),
            //     ),
            //   ),
            //   SearchResult.food: ClipRRect(
            //     borderRadius: BorderRadius.circular(8.0),
            //     child: CachedNetworkImage(
            //       height: 40,
            //       width: 40,
            //       fit: BoxFit.cover,
            //       imageUrl: suggestion.type == SearchResult.food
            //           ? (suggestion.data as Farmaco).image?.url ?? ""
            //           : (suggestion.data as Shop).image?.url ?? "",
            //       placeholder: (context, url) => Image.asset(
            //         'assets/img/loading.gif',
            //         fit: BoxFit.cover,
            //         height: 40,
            //         width: 40,
            //       ),
            //       errorWidget: (context, url, error) => Icon(Icons.error),
            //     ),
            //   ),
            //   //SearchResult.address: Icon(Icons.location_on_outlined)
            // }),
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
          switch (suggestion.type) {
            case SearchResult.restaurant:
              {
                print("shop");
                ref.read(currentShopIDProvider.notifier).state =
                    (suggestion.data as Shop).id!;
                Navigator.of(context).pushNamed(
                  'Store',
                  arguments: suggestion.data as Shop,
                );
              }
              break;

            case SearchResult.food:
              {
                print("food");
                Navigator.of(context).pushNamed(
                  'Product',
                  arguments: suggestion.data as Farmaco,
                );
              }
              break;

            case SearchResult.address:
              {
                ref.read(suggestedAddressProvider.notifier).state =
                    suggestion.data as Address;
                print("address");
                Navigator.of(context).pushNamed(
                  'ShopsAddress',
                );
              }
              break;

            default:
              {
                print("default");
              }
              break;
          }
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
        SearchResult search = SearchResult(
            text: product.name!,
            id: product.id!,
            route: 'Farmaco',
            type: SearchResult.food,
            data: product);
        elements.add(search);
      }
      if (widget.restaurant_id == null) {
        var shops = await searchRestaurants(value);
        for (var shop in shops) {
          SearchResult search = SearchResult(
              text: shop.name,
              id: shop.id,
              route: 'Restaurant',
              type: SearchResult.restaurant,
              data: shop);
          elements.add(search);
        }
      }
      if (widget.restaurant_id == null) {
        var suggestionAddress = await searchCity(address: value) ?? '';
        final address = await getAddressFromSuggestion(suggestionAddress);
        print("address: ${address.latitude}");
        if (suggestionAddress != null && suggestionAddress != '') {
          SearchResult search = SearchResult(
              text: suggestionAddress,
              type: SearchResult.address,
              data: address);
          elements.insert(0, search);
        }
      }
    }
    return elements;
  }
}

Future<Address> getAddressFromSuggestion(String suggestion) async {
  Address newAddress = Address.fromJSON({});
  newAddress.address = suggestion;
  var position =
      await GeocodingPlatform.instance.locationFromAddress(newAddress.address!);
  newAddress.latitude = position.first.latitude;
  newAddress.longitude = position.first.longitude;
  newAddress.address = newAddress.address!.replaceAll(',', ' -');
  return newAddress;
}
