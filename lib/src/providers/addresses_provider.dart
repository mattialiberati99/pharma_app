// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

// Project imports:
import '../models/address.dart';
import '../repository/settings_repository.dart';
import '../repository/addresses_repository.dart' as addressRepo;

final addressesProvider = ChangeNotifierProvider<AddressesProvider>((ref) {
  return AddressesProvider();
});

class AddressesProvider with ChangeNotifier {
  List<Address> addresses = [];
  String? suggestion;

  AddressesProvider() {
    Future.delayed(Duration.zero, () async {
      addresses.addAll(await addressRepo.getAddresses());
      notifyListeners();
    });
  }

  addAddressFromSuggestion() async {
    Address newAddress = Address.fromJSON({});
    newAddress.address = suggestion;
    var position = await GeocodingPlatform.instance
        .locationFromAddress(newAddress.address!);
    newAddress.latitude = position.first.latitude;
    newAddress.longitude = position.first.longitude;
    newAddress.description = currentUser.value.name;
    newAddress.address = newAddress.address!.replaceAll(',', ' -');
    addAddress(newAddress);
  }

  addAddress(Address address) {
    addressRepo.addAddress(address).then((value) {
      addresses.insert(0, value);
      notifyListeners();
    });
  }

  // updateAddress({required BuildContext context,required Address address}) async{
  //   if(address.latitude==null || address.longitude==null){
  //     address =
  //         (await requirePositionPick(
  //         address: address,
  //         context: context))!;
  //   }
  //   addresses.removeWhere((element) => element.id==address.id);
  //   addressRepo.updateAddress(address).then((value) {
  //     addresses.insert(0, value);
  //     notifyListeners();
  //   });
  // }

  removeAddress(Address address) {
    addressRepo.removeDeliveryAddress(address).then((value) {
      notifyListeners();
    });
  }

  searchAddress({required String address}) async {
    suggestion = await addressRepo.searchAddress(address: address);
    notifyListeners();
  }

  // Future<Address?> requirePositionPick({required Address address, required BuildContext context, bool animate = false}) async {
  //   await showLocationPicker(
  //     context,
  //     setting.value.googleMapsKey!,
  //     hintText: "Seleziona la tua posizione iniziale",
  //     // TODO ? placeName: address.address,
  //     initialCenter: LatLng(address.latitude ?? Address.defaultLatitude, address.longitude ?? Address.defaultLongitude),
  //     initialZoom: 6,
  //     language: 'it',
  //     countries: ['it'],
  //     layersButtonEnabled: false,
  //     automaticallyAnimateToCurrentLocation: animate ? true : false,
  //     myLocationButtonEnabled: true,
  //   ).then((value) {
  //     address.latitude = value?.latLng.latitude;
  //     address.longitude = value?.latLng.longitude;
  //     return address;
  //   }).catchError((error, stack) {
  //     print(error);
  //     print(stack);
  //     return null;
  //   });
  //   return address;
  // }
}
