import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/delivery_addresses/widgets/delivery_addresses_Item.dart';
import 'package:pharma_app/src/pages/delivery_addresses/widgets/empty_addresses_widget.dart';
import 'package:pharma_app/src/providers/user_addresses_provider.dart';

import '../../../generated/l10n.dart';
import '../../components/custom_app_bar.dart';
import '../../dialogs/UpdateRecapitoDialog.dart';
import '../../models/address.dart';
import '../../providers/addresses_provider.dart';
import '../../providers/cart_provider.dart';

class SearchAddressPage extends ConsumerStatefulWidget {
  final bool? isOrder;

  const SearchAddressPage({
    Key? key,
    this.isOrder,
  }) : super(key: key);

  @override
  ConsumerState<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends ConsumerState<SearchAddressPage> {
  // String address = "null";
  String autocompletePlace = "null";

  // late AddressesProvider addressProv;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // addressProv = ref.read(addressesProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addressProv = ref.watch(addressesProvider);
    final cartProv = ref.watch(cartProvider);

    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).delivery_address),
      body: SafeArea(
        child: Column(
          children: [
            PlacesAutocomplete(
              topCardShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              searchController: _controller,
              apiKey: "AIzaSyDqE_SdM4oS7sbE9ALyuc8vJzDmSVocLVM",
              language: "it",
              searchHintText: context.loc.search_address_hint,
              mounted: mounted,
              showBackButton: false,
              onGetDetailsByPlaceId: (PlacesDetailsResponse? result) {
                if (result != null) {
                  autocompletePlace = result.result.formattedAddress ?? "";
                  addressProv.suggestion = autocompletePlace;
                  addressProv.addAddressFromSuggestion();
                  addressProv.suggestion = null;
                }
              },
            ),
            // ListTile(
            //   title: Text("Geocoded Address: $address"),
            // ),
            addressProv.addresses.isEmpty
                ? EmptyAddressesWidget()
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: addressProv.addresses.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return DeliveryAddressesItem(
                            address: addressProv.addresses.elementAt(index),
                            onPressed: (Address _address) async {
                              if (widget.isOrder!) {
                                print("is order");

                                cartProv.deliveryAddress = _address;
                                ref.refresh(userDefaultCartAddressProvider);
                                Navigator.of(context).pop();
                                // Helper.nextOrderPage(context, cartProv);
                              } else {
                                print("address");

                                //Navigator.of(context).pop();
                              }
                            },
                            onLongPress: (Address _address) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => UpdateRecapitoDialog(
                                        address: _address,
                                      )).then((value) async {
                                if (kDebugMode) {
                                  print(value);
                                }
                                // if (value != null && value is Address) {
                                //   addressProv.updateAddress(
                                //       address: value, context: context);
                                //   if (!widget.isOrder!) {
                                //     posProv.changeCurrentLocation(value);
                                //   }
                                //
                                //   setState(() {});
                                // }
                              });
                            },
                            onDismissed: (Address _address) {
                              addressProv.removeAddress(_address);
                              ref.refresh(addressesProvider);
                              ref.refresh(userAddressesProvider.future);
                            });
                      },
                    ),
                  ),
            // ListTile(
            //   title: Text(
            //       "Autocomplete Address: $autocompletePlace"),
            // ),
          ],
        ),
      ),
    );
  }
}
