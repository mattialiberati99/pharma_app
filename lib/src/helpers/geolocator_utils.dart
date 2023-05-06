import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart' as Interf;
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as MapsPlace;
import 'package:http/http.dart';


class GeoLocatorUtils {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions are denied the `Future` will return an error.
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) return Future.error('Location permissions are permanently denied, we cannot request permissions.');

    return await Geolocator.getCurrentPosition(desiredAccuracy: Interf.LocationAccuracy.medium);
  }

  /// Determine the last known position of the device.
  static Future<Position?> getLastKnownPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) return Future.error('Location permissions are permanently denied, we cannot request permissions.');

    return await Geolocator.getLastKnownPosition();
  }

  /// Decode address from latitude & longitude
  static Future<String> decodeAddress(
  {required MapsPlace.Location location,
      String? apiKey,
      String? baseUrl,
      Client? httpClient,
      Map<String, String>? apiHeaders,
      String? language,
      List<String> resultType = const [],
      List<String> locationType = const [] }) async {
    String address = '';
    GeocodingResult? _geocodingResult;
    late List<GeocodingResult> _geocodingResultList = [];
    try {
      final geocoding = GoogleMapsGeocoding(
        apiKey: apiKey,
        baseUrl: baseUrl,
        apiHeaders: apiHeaders,
        httpClient: httpClient,
      );
      final response = await geocoding.searchByLocation(
        location,
        language: language,
        locationType: locationType,
        resultType: resultType,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        debugPrint(response.errorMessage);
        address = response.status;

        return response.errorMessage ??
            "Address not found, something went wrong!";
      }
      address = response.results.first.formattedAddress ?? "";
      _geocodingResult = response.results.first;
      if (response.results.length > 1) {
        _geocodingResultList = response.results;
      }
      return address;
    } catch (e) {
      return e.toString();
    }
  }

}
