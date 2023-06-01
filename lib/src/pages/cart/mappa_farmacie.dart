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

import '../../components/flat_button.dart';
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

  double lat = 0.0;
  double long = 0.0;

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
    getPosition;
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
                mapToolbarEnabled: true,
                mapType: MapType.terrain,
                scrollGesturesEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: baseLatLng, zoom: 11),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                // markers: data!
                //     .map((e) => Marker(
                //         markerId: MarkerId(randomString(5)),
                //         onTap: () {
                //           setState(() {
                //             _currentIndex = e;
                //           });
                //         },
                //         icon: _currentIndex == e ? selectedIcon : defaultIcon,
                //         consumeTapEvents: true,
                //         anchor: const Offset(0.5, 0.5),
                //         position:
                //             LatLng(e.from!.latitude!, e.from!.longitude!)))
                //     .toSet(),
                circles: {
                  Circle(
                    circleId: const CircleId("-1"),
                    center: baseLatLng,
                    radius: 400,
                    fillColor: Colors.blue.shade100.withOpacity(0.5),
                    strokeColor: Colors.blue.shade100.withOpacity(0.1),
                  )
                }),
          ),
          Positioned(
            height: 285,
            left: 0,
            right: 0,
            child: Card(
              elevation: 1,
              color: Colors.white,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              borderOnForeground: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset('assets/immagini_pharma/Rectangle.png'),
                  const SizedBox(height: 30),
                  const Text(
                    'Scegli la tua farmacia preferita',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.gray8,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                    'Farmacia Bresciani',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Via Roma 340, 12345 Verona, VR, Italia',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 171, 148),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Conferma',
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Annulla",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
