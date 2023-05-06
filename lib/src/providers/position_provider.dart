import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_app/src/providers/settings_provider.dart';

import '../../generated/l10n.dart';
import '../dialogs/ConfirmDialog.dart';
import '../helpers/app_config.dart';
import '../models/address.dart' as M;
import '../repository/addresses_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/settings_repository.dart' as settingRepo;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../repository/settings_repository.dart';

final positionProvider = ChangeNotifierProvider<PositionProvider>((ref) {
  return PositionProvider();
});

class PositionProvider with ChangeNotifier {
  static M.Address currentAddress = M.Address();
  String? suggestion;
  LatLng basePosition = LatLng(45.352011, 10.169139);

  M.Address getAddress() => currentAddress;

  Future<M.Address?> refreshAddress(BuildContext context) async {
    if (await silentRefresh()) {
    } else {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        showDialog(
            context: context,
            builder: (context) => ConfirmDialog(
                  title: S.current.permission_denied,
                  description: S.current.enable_localisation,
                  icon: Icons.location_disabled,
                  action: MaterialButton(
                    shape: const StadiumBorder(),
                    color: AppColors.primary,
                    child: Text(
                      S.current.confirmation,
                      //style: TextStyles.normalBlack,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await Geolocator.openAppSettings();
                      //return refreshAddress(context);
                    },
                  ),
                ));
      } else {
        Geolocator.requestPermission();
      }
    }

    if (currentAddress.latitude != null) {
    } else {
      currentAddress = await getDefaultAddress();
    }
    if (currentAddress.latitude == null || currentAddress.longitude == null) {
      currentAddress.latitude = basePosition.latitude;
      currentAddress.longitude = basePosition.longitude;
    }
    notifyListeners();

    return currentAddress;
  }

  silentRefresh() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position? lastLocation;
      try {
        lastLocation = (await Geolocator.getLastKnownPosition())!;
      } catch (e) {}
      if (lastLocation != null) {
        print("known");
        //settingRepo.setCurrentLocation();
        currentAddress.latitude = lastLocation.latitude;
        currentAddress.longitude = lastLocation.longitude;
        currentAddress.address = (await Geocoder2.getDataFromCoordinates(
                latitude: lastLocation.latitude,
                longitude: lastLocation.longitude,
                googleMapApiKey: setting.value.googleMapsKey!))
            .city;
        notifyListeners();
        return true;
      } else {
        if (await Geolocator.isLocationServiceEnabled()) {
          print("locanow");
          try {
            lastLocation = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium,
                timeLimit: Duration(seconds: 3));
          } catch (e) {}
          if (lastLocation != null) {
            //settingRepo.setCurrentLocation();
            currentAddress.latitude = lastLocation.latitude;
            currentAddress.longitude = lastLocation.longitude;
            currentAddress.address = (await Geocoder2.getDataFromCoordinates(
                    latitude: lastLocation.latitude,
                    longitude: lastLocation.longitude,
                    googleMapApiKey: setting.value.googleMapsKey!))
                .city;
            notifyListeners();
            return true;
          }
        }
      }
    }
    return false;
  }

  getFromAPI() async {
    currentAddress = await getDefaultAddress();
    if (currentAddress.latitude == null || currentAddress.longitude == null) {
      currentAddress.latitude = basePosition.latitude;
      currentAddress.longitude = basePosition.longitude;
    }
    notifyListeners();
  }

  void searchAddress({required String address}) async {
    String API = setting.value.googleMapsKey!;
    String _add = address.replaceAll(" ", "+");
    String randomToken = randomNumeric(10);
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${_add}&origin=${basePosition.latitude},${basePosition.longitude}&components=country:it&type=address&language=it&key=${API}&sessiontoken=${randomToken}';
    var resp = await http.get(Uri.parse(url));
    //print(url);
    //print(resp.body);
    List predictions = json.decode(resp.body)['predictions'];
    if (predictions != null && predictions.isNotEmpty) {
      suggestion = json.decode(resp.body)['predictions'][0]['description'];
      print(resp.body);
    } else {
      suggestion = null;
    }
    notifyListeners();
  }

  void searchCity({required String address}) async {
    String API = setting.value.googleMapsKey!;
    String _add = address.replaceAll(" ", "+");
    String randomToken = randomNumeric(10);
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${_add}&origin=${basePosition.latitude},${basePosition.longitude}&components=country:it&type=(cities)&language=it&key=$API&sessiontoken=${randomToken}';
    var resp = await http.get(Uri.parse(url));
    //print(url);
    //print(resp.body);
    List predictions = json.decode(resp.body)['predictions'];
    if (predictions != null && predictions.isNotEmpty) {
      suggestion = json.decode(resp.body)['predictions'][0]['description'];
      //print(resp.body);
    } else {
      suggestion = null;
    }
    notifyListeners();
  }

  Future<M.Address> changeCurrentLocation(M.Address _address) async {
    M.Address address = new M.Address()
      ..latitude = _address.latitude
      ..longitude = _address.longitude
      ..id = "1"
      ..address = "start position";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_address', json.encode(address.toMap()));
    return address;
  }

  Future<M.Address> getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//  await prefs.clear();
    if (prefs.containsKey('my_address')) {
      currentAddress =
          M.Address.fromJSON(json.decode(prefs.getString('my_address')!));
      return currentAddress;
    } else {
      currentAddress = M.Address.fromJSON({});
      return M.Address.fromJSON({});
    }
  }
}
