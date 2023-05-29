import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pharma_app/src/components/search_bar/search_bar_terapie.dart';

import '../../components/drawer/app_drawer.dart';
import '../../components/meds_app_bar.dart';
import '../../components/bottomNavigation.dart';
import '../../components/search_bar/shop_search_bar.dart';
import '../../models/farmaco.dart';

class TerapieScreen extends StatefulWidget {
  @override
  State<TerapieScreen> createState() => _TerapieScreenState();
}

class _TerapieScreenState extends State<TerapieScreen> {
  List<Farmaco> leMieTerapie = [];
  final _searchController = TextEditingController(text: '');
  Farmaco? selectedProduct;

  void selectProduct(Farmaco selectedProduct) {
    setState(() {
      this.selectedProduct = selectedProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    if (leMieTerapie.isEmpty) {
      return Scaffold(
        body: Container(
          padding: new EdgeInsets.all(26),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                'Le mie terapie',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '0 totali',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Image(
                  image: AssetImage('assets/immagini_pharma/404.png'),
                  width: 150,
                  height: 130,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 210,
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
                              height: MediaQuery.of(context).size.height * 0.95,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height: 50),
                                  const Text('Aggiungi il farmaco'),
                                  const SizedBox(height: 20),
                                  SearchBarTerapie(callback: selectProduct),
                                  const SizedBox(height: 20),
                                  selectedProduct != null
                                      ? Center(
                                          child: Column(
                                            children: [
                                              Image(
                                                  image: NetworkImage(
                                                      selectedProduct!
                                                          .image!.url!)),
                                              const SizedBox(height: 15),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.10,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image(
                                                          image: NetworkImage(
                                                              selectedProduct!
                                                                  .image!.url!),
                                                          width: 50,
                                                          height: 50),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            selectedProduct!
                                                                .name!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: SizedBox(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: ElevatedButton(
                                                    onPressed: () => {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              ''),
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              47,
                                                              171,
                                                              148),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Continua',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text(''),
                                  //Text(selectedProduct?.name ?? '  '),
                                ],
                              ),
                            );
                          },
                        ).whenComplete(() {
                          setState(() {
                            selectedProduct = null;
                          });
                        });
                        print(selectedProduct!.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 47, 171, 148),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Aggiungi terapia',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: Text('pieno'));
    }
  }
}
