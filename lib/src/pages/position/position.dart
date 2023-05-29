import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/repository/settings_repository.dart';
import '../../components/custom_map_location_picker.dart';
import '../../helpers/geolocator_utils.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as GeoLocator;
import 'package:google_maps_webservice/places.dart' as MapsPlace;

import '../../models/address.dart';

final userPositionProvider = FutureProvider.autoDispose<LatLng>(
  (ref) async {
    Position? lastLocation = await GeoLocatorUtils.getLastKnownPosition();
    if (lastLocation != null) {
      return LatLng(lastLocation.latitude, lastLocation.longitude);
    } else {
      final location = await GeoLocatorUtils.getCurrentPosition();
      return LatLng(location.latitude, location.longitude);
    }
  },
  name: 'UserPosition',
);

class PositionPage extends ConsumerStatefulWidget {
  /// GPS accuracy for the map
  final GeoLocator.LocationAccuracy desiredAccuracy;

  const PositionPage({
    Key? key,
    this.desiredAccuracy = GeoLocator.LocationAccuracy.high,
  }) : super(key: key);

  @override
  ConsumerState<PositionPage> createState() => _PositionPageState();
}

class _PositionPageState extends ConsumerState<PositionPage> {
  final _sheetController = DraggableScrollableController();

  /// Map controller for movement & zoom
  final Completer<GoogleMapController> _mapController = Completer();

  /// initial zoom level
  late double _zoom = 18.0;

  /// initial latitude & longitude
  late LatLng _initialPosition;

  String address = "null";

  @override
  void initState() {
    _initialPosition = ref.read(userPositionProvider).value!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentLatLng = ref.watch(userPositionProvider).value;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight * 0.75,
                // TODO: Togliere blocco commento
                /* child: CustomMapLocationPicker(
                  language: 'it',
                  apiKey: 'AIzaSyDqE_SdM4oS7sbE9ALyuc8vJzDmSVocLVM',
                  mapType: MapType.normal,
                  currentLatLng: currentLatLng,
                  onMapTap: (GeocodingResult? result) async {
                    if (result != null) {
                      setState(() {
                        address = result.formattedAddress ?? "";
                        // mapAddress.value = result.formattedAddress ?? "";
                      });
                    }
                  },
                ), */
              );
            },
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.30,
            minChildSize: 0.30,
            maxChildSize: 1,
            snapSizes: [0.30, 0.5],
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return ListView(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.zero,
                controller: scrollController,
                children: [
                  DecoratedBox(
                    decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        )),
                    child: SizedBox(
                      height: context.mqh,
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          return Column(
                            children: [
                              const SizedBox(
                                  width: 50,
                                  child: Divider(
                                    color: AppColors.secondColor,
                                    thickness: 5,
                                    height: 20,
                                  )),
                              const SizedBox(height: 16),
                              Text(
                                'Aggiungi un indirizzo di consegna',
                                style: context.textTheme.subtitle1
                                    ?.copyWith(fontSize: 20),
                              ),
                              // create a fake textfield with search icon and gray background
                              // to make the search bar look like a textfield
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed('SearchAddress'),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.gray6,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.search),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: IgnorePointer(
                                          child: TextField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: context
                                                  .loc.search_address_hint,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    TextButton.icon(
                                        onPressed: () async {
                                          // _initialPosition = currentLatLng!;
                                          // final controller = await _mapController.future;
                                          // controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition()));
                                          // setState(() {});
                                          final decodedAddress =
                                              await GeoLocatorUtils.decodeAddress(
                                                  apiKey:
                                                      'AIzaSyDqE_SdM4oS7sbE9ALyuc8vJzDmSVocLVM',
                                                  location: MapsPlace.Location(
                                                      lat: currentLatLng!
                                                          .latitude,
                                                      lng: currentLatLng
                                                          .longitude));

                                          setState(() {
                                            address = decodedAddress;
                                          });
                                          await changeCurrentAddressFromLAtLng(
                                              currentLatLng);
                                        },
                                        icon: CircleAvatar(
                                            backgroundColor: AppColors
                                                .secondColor
                                                .withOpacity(0.2),
                                            foregroundColor:
                                                AppColors.secondColor,
                                            radius: 18,
                                            child: Icon(Icons.near_me_sharp)),
                                        label: Text(
                                          'Usa la posizione attuale',
                                          style: context.textTheme.subtitle1
                                              ?.copyWith(
                                                  fontSize: 18,
                                                  color: AppColors.secondColor),
                                        )),
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(address == 'null'
                                    ? ''
                                    : "Indirizzo: $address"),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                  //TODO inserire contenuto
                ],
              );
            },
          ),
          Positioned(
            left: 8,
            top: context.mqh * 0.065,
            child: OutlinedButton(
                //TODO riutilizzare
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  backgroundColor:
                      MaterialStateProperty.all(context.colorScheme.onPrimary),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF333333),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  /// Camera position moved to location
  CameraPosition cameraPosition() {
    return CameraPosition(
      target: _initialPosition,
      zoom: _zoom,
    );
  }

  Future<dynamic> setUserAddressFromLatLng() async {
    final currentLatLng = ref.watch(userPositionProvider).value;
    final whenDone = new Completer();

    Address _address = new Address();

    String _addressName = '';
    _address = Address.fromJSON({
      'address': _addressName,
      'latitude': currentLatLng?.latitude,
      'longitude': currentLatLng?.longitude
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_address', json.encode(_address.toMap()));
    whenDone.complete(_address);
    return whenDone.future;
  }
}
