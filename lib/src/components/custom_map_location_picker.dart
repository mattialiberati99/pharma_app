import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import "package:google_maps_webservice/geocoding.dart";
import 'package:google_maps_webservice/places.dart' as MapsPlace;

class CustomMapLocationPicker extends StatefulWidget {
  /// Padding around the map
  final EdgeInsets padding;

  /// Compass for the map (default: true)
  final bool compassEnabled;

  /// Lite mode for the map (default: false)
  final bool liteModeEnabled;

  /// API key for the map & places
  final String apiKey;
  /// GPS accuracy for the map
  final LocationAccuracy desiredAccuracy;

  /// GeoCoding base url
  final String? geoCodingBaseUrl;

  /// GeoCoding http client import 'package:http/http.dart';
  final Client? geoCodingHttpClient;

  /// GeoCoding api headers
  final Map<String, String>? geoCodingApiHeaders;

  /// GeoCoding result type
  final List<String> resultType;

  /// GeoCoding location type
  final List<String> locationType;

  /// Language code for Places API results
  /// language: 'en',
  final String? language;

  /// currentLatLng init location for camera position
  /// currentLatLng: Location(lat: -33.852, lng: 151.211),
  final LatLng? currentLatLng;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Map type (default: MapType.normal)
  final MapType mapType;

  /// Search text field controller
  final TextEditingController? searchController;

  /// On Map Tap Callback
  final Function(GeocodingResult?) onMapTap;

  const CustomMapLocationPicker({
    Key? key,
    this.desiredAccuracy = LocationAccuracy.high,
    required this.apiKey,
    this.geoCodingBaseUrl,
    this.geoCodingHttpClient,
    this.geoCodingApiHeaders,
    this.language,
    this.locationType = const [],
    this.resultType = const [],
    this.padding = const EdgeInsets.all(0),
    this.compassEnabled = true,
    this.liteModeEnabled = false,
    this.minMaxZoomPreference = const MinMaxZoomPreference(10, 20),
    this.mapType = MapType.normal,
    this.currentLatLng = const LatLng(45.43304174346144, 11.02422462706511),
    this.searchController,
    required this.onMapTap,

  }) : super(key: key);

  @override
  State<CustomMapLocationPicker> createState() => _CustomMapLocationPickerState();
}

class _CustomMapLocationPickerState extends State<CustomMapLocationPicker> {
  /// Search text field controller for autocomplete
  late TextEditingController _searchController = TextEditingController();

  /// Map controller for movement & zoom
  final Completer<GoogleMapController> _controller = Completer();

  /// GeoCoding result for further use
  GeocodingResult? _geocodingResult;

  /// GeoCoding results list for further use
  late List<GeocodingResult> _geocodingResultList = [];

  /// initial latitude & longitude
  late LatLng _initialPosition = const LatLng(45.433022921262946, 11.024525034285526);

  /// initial address text
  late String _address = "Tap on map to get address";

  /// Map type (default: MapType.normal)
  late MapType _mapType = MapType.normal;
  /// initial zoom level
  late double _zoom = 18.0;

  /// Camera position moved to location
  CameraPosition cameraPosition() {
    return CameraPosition(
      target: _initialPosition,
      zoom: _zoom,
    );
  }

  @override
  void initState() {
    _initialPosition = widget.currentLatLng ?? _initialPosition;
    _mapType = widget.mapType;
    _searchController = widget.searchController ?? _searchController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      minMaxZoomPreference: widget.minMaxZoomPreference,
      onCameraMove: (CameraPosition position) {
        /// set zoom level
        _zoom = position.zoom;
      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: _zoom,
      ),
      onTap: (LatLng position) async {
        _initialPosition = position;
        final controller = await _controller.future;
        controller.animateCamera(
            CameraUpdate.newCameraPosition(cameraPosition()));
        _decodeAddress(
            MapsPlace.Location(lat: position.latitude, lng: position.longitude));
        setState(() {});
        widget.onMapTap.call(_geocodingResult);
      },
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
      },
      markers: {
        Marker(
          markerId: const MarkerId('one'),
          position: _initialPosition,
        ),
      },
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      padding: widget.padding,
      compassEnabled: widget.compassEnabled,
      liteModeEnabled: widget.liteModeEnabled,
      mapType: widget.mapType,
    );
  }

  /// Decode address from latitude & longitude
  void _decodeAddress(MapsPlace.Location location) async {
    try {
      final geocoding = GoogleMapsGeocoding(
        apiKey: widget.apiKey,
        baseUrl: widget.geoCodingBaseUrl,
        apiHeaders: widget.geoCodingApiHeaders,
        httpClient: widget.geoCodingHttpClient,
      );
      final response = await geocoding.searchByLocation(
        location,
        language: widget.language,
        locationType: widget.locationType,
        resultType: widget.resultType,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        debugPrint(response.errorMessage);
        _address = response.status;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ??
                  "Address not found, something went wrong!"),
            ),
          );
        }
        return;
      }
      _address = response.results.first.formattedAddress ?? "";
      _geocodingResult = response.results.first;
      if (response.results.length > 1) {
        _geocodingResultList = response.results;
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
