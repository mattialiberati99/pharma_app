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
import 'package:pharma_app/src/providers/cart_provider.dart';
import 'dart:async';

import '../../components/flat_button.dart';
import '../../helpers/app_config.dart';
import '../../providers/shops_provider.dart';

class MappaFarmacie extends ConsumerStatefulWidget {
  final double prOrd;
  const MappaFarmacie({super.key, required this.prOrd});

  @override
  ConsumerState<MappaFarmacie> createState() => _MappaFarmacieState();
}

class _MappaFarmacieState extends ConsumerState<MappaFarmacie> {
  late BitmapDescriptor customicon;
  late GoogleMapController _googleMapController;
  late StreamSubscription<Position> streamSubscription;
  Set<Marker> markers = Set();
  TextEditingController timeinput = TextEditingController();
  late TimeOfDay time;

  TextEditingController codiceFiscaleController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController noteController = TextEditingController();

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
    // final cart = ref.watch(cartProvider);

    // final products = cart.carts;

    // final farmacie = ref.watch(nearestShopsProviderWithProducts());

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
                mapType: MapType.normal,
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
                            backgroundColor: Color.fromARGB(249, 249, 249, 249),
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.96,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Scaffold(
                                    bottomSheet: Container(
                                      width: double.infinity,
                                      height: 120,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // TODO
                                                  Navigator.of(context).pop();
                                                  showModalBottomSheet(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      20)),
                                                    ),
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            249, 249, 249, 249),
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.96,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                          child: Scaffold(
                                                            bottomSheet:
                                                                Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 120,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          50,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {},
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              47,
                                                                              171,
                                                                              148),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(18),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'Conferma',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Annulla",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    249,
                                                                    249,
                                                                    249),
                                                            body: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.95,
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Image.asset(
                                                                            'assets/immagini_pharma/Rectangle.png'),
                                                                        Row(
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                icon: const Icon(Icons.arrow_back_ios),
                                                                              ),
                                                                              const SizedBox(width: 50),
                                                                              const Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text('Salta la fila e ritira in farmacia', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                              ),
                                                                            ]),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              color: Colors.white),
                                                                          height:
                                                                              470,
                                                                          width:
                                                                              MediaQuery.of(context).size.width - 30,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(20.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                const Text(
                                                                                  'Riepilogo per il ritiro',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                ),
                                                                                const SizedBox(height: 20),
                                                                                const Text(
                                                                                  'Dati Farmacia',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                ),
                                                                                const SizedBox(height: 20),
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: const [
                                                                                    Text('F. Bresciani'),
                                                                                    Text('Via Roma 3400,12345 Verona, VR, Italia'),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 20),
                                                                                Row(
                                                                                  children: [
                                                                                    const Text(
                                                                                      'Numero Telefono: ',
                                                                                      style: TextStyle(color: AppColors.primary),
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    Text(telefonoController.text),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(height: 20),
                                                                                const Text(
                                                                                  'Dettagli per il ritiro',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                ),
                                                                                const SizedBox(height: 15),
                                                                                Text(codiceFiscaleController.text),
                                                                                const SizedBox(height: 10),
                                                                                Row(
                                                                                  children: [
                                                                                    const Text(
                                                                                      'Orario di ritiro: ',
                                                                                      style: TextStyle(color: AppColors.primary),
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    Text(timeinput.text),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(10.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text('Totale'),
                                                                              Text('${widget.prOrd}€', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 47, 171, 148),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Procedi',
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
                                    backgroundColor:
                                        Color.fromARGB(255, 249, 249, 249),
                                    body: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.95,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Image.asset(
                                                    'assets/immagini_pharma/Rectangle.png'),
                                                Row(children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_back_ios),
                                                  ),
                                                  const SizedBox(width: 50),
                                                  const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Salta la fila e ritira in farmacia',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ]),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white),
                                                  height: 470,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Informazioni per il ritiro',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: const [
                                                            Text(
                                                                'F. Bresciani'),
                                                            Text(
                                                                'Via Roma 3400,12345 Verona, VR, Italia'),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        TextFormField(
                                                          controller:
                                                              codiceFiscaleController,
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Codice fiscale'),
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              telefonoController,
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Telefono'),
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              noteController,
                                                          obscureText: false,
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Note'),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        const Text(
                                                          'Seleziona un orario indicativo per il ritiro',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        ),
                                                        SizedBox(
                                                          width: 170,
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                              color: timeinput
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            controller:
                                                                timeinput,
                                                            cursorColor:
                                                                AppColors.gray5,
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: AppColors
                                                                        .gray5),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              focusedBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .gray5,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: AppColors
                                                                        .gray5),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              hintText:
                                                                  'Orario',
                                                              //hintStyle: TextStyles.mediumGrey,
                                                              filled: true,
                                                              fillColor: timeinput
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? AppColors
                                                                      .primary
                                                                  : Colors
                                                                      .white,

                                                              prefix:
                                                                  const SizedBox(
                                                                width: 16,
                                                              ),
                                                              prefixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16.0),
                                                                child: Icon(
                                                                  Icons.alarm,
                                                                  color: timeinput
                                                                          .text
                                                                          .isNotEmpty
                                                                      ? Colors
                                                                          .white
                                                                      : AppColors
                                                                          .gray4,
                                                                ),
                                                              ),
                                                              prefixIconConstraints:
                                                                  const BoxConstraints(
                                                                maxWidth: 40,
                                                                maxHeight: 40,
                                                              ),
                                                            ),
                                                            readOnly: true,
                                                            onTap: () async {
                                                              TimeOfDay?
                                                                  pickedTime =
                                                                  await showTimePicker(
                                                                builder:
                                                                    (context,
                                                                        child) {
                                                                  return Theme(
                                                                      child:
                                                                          child!,
                                                                      data: Theme.of(context).copyWith(
                                                                          colorScheme: const ColorScheme.light(
                                                                              primary: AppColors.primary,
                                                                              onPrimary: Colors.black,
                                                                              onSurface: Colors.grey)));
                                                                },
                                                                context:
                                                                    context,
                                                                initialTime:
                                                                    TimeOfDay
                                                                        .now(),
                                                              );

                                                              //DateTime.now() - not to allow to choose before today.

                                                              if (pickedTime !=
                                                                  null) {
                                                                setState(() {
                                                                  time =
                                                                      pickedTime;
                                                                  timeinput
                                                                          .text =
                                                                      '${time.hour} : ${time.minute}';
                                                                });
                                                              } else {
                                                                print(
                                                                    "Time is not selected");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Totale'),
                                                      Text('${widget.prOrd}€',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
