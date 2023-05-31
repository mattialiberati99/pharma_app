import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../../helpers/app_config.dart';

class MappaFarmacie extends ConsumerStatefulWidget {
  const MappaFarmacie({super.key});

  @override
  ConsumerState<MappaFarmacie> createState() => _MappaFarmacieState();
}

class _MappaFarmacieState extends ConsumerState<MappaFarmacie> {
  late BitmapDescriptor customicon;
  late GoogleMapController _googleMapController;
  late StreamSubscription<Position> streamSubscription;
  Set<Marker> markers = Set();

  late double lat;
  late double long;

  BitmapDescriptor defaultIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue); //default marker
  BitmapDescriptor selectedIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed); //selected marker

  void _onMapCreated(GoogleMapController _cntlr) {
    _googleMapController = _cntlr;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    getPosition();

    getBytesFromAsset('assets/ico/marker_selected.png', 64).then((onValue) {
      selectedIcon = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/ico/marker_uselected.png', 64).then((onValue) {
      defaultIcon = BitmapDescriptor.fromBytes(onValue);
      // BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(12, 12)),
      //     'assets/ico/marker_selected.png')
      //     .then((d) {
      //   selectedIcon = d;
      // });
    });
    super.initState();
  }

  getPosition() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test permesso
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('La geolocalizzazione non è attiva.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permessi di geolocalizzazione non permessi');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Permessi di localizzazione rifiutati in modo permanente.');
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      lat = position.latitude;
      long = position.longitude;
      getAddressFromLatLang(position);
    });
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.low);
    // print(position.latitude);
    // print(position.longitude);
  }

  Future<String?> getAddressFromLatLang(Position position) async {
    String? address;
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.latitude);
    Placemark place = placemark[0];
    address = place.locality;
    return address;
  }

  @override
  Widget build(BuildContext context) {
    final baseLatLng = LatLng(long, lat);

    Size s = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: s.height,
            width: s.width,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(41.902782, 12.496365)),
            ),
          ),
        ],
      ),
    );
  }
}
