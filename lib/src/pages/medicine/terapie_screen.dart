import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pharma_app/src/components/search_bar/search_bar_terapie.dart';

import '../../components/flat_button.dart';
import '../../models/farmaco.dart';

class TerapieScreen extends StatefulWidget {
  @override
  State<TerapieScreen> createState() => _TerapieScreenState();
}

class _TerapieScreenState extends State<TerapieScreen> {
  List<Farmaco> leMieTerapie = [];
  final _searchController = TextEditingController(text: '');
  final _creaTerapiaController = TextEditingController();
  Farmaco? selectedProduct;

  void selectProduct(Farmaco selectedProduct) {
    setState(() {
      this.selectedProduct = selectedProduct;
    });
  }

  void dispose() {
    _searchController.dispose();
    _creaTerapiaController.dispose();
    super.dispose();
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
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Image.asset(
                                          'assets/immagini_pharma/Rectangle.png'),
                                      const SizedBox(height: 30),
                                      const Text(
                                        'Aggiungi un nome alla terapia:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: TextFormField(
                                          controller: _creaTerapiaController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none),
                                            ),
                                            labelText: 'Nome terapia',
                                            contentPadding: EdgeInsets.all(16),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _creaTerapiaController.text == ""
                                                  ? null
                                                  : showModalBottomSheet(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20)),
                                                      ),
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.95,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              const SizedBox(
                                                                  height: 50),
                                                              const Text(
                                                                  'Aggiungi il farmaco'),
                                                              const SizedBox(
                                                                  height: 20),
                                                              SearchBarTerapie(
                                                                  callback:
                                                                      selectProduct),
                                                              const SizedBox(
                                                                  height: 20),
                                                              selectedProduct !=
                                                                      null
                                                                  ? Center(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Image(
                                                                              image: NetworkImage(selectedProduct!.image!.url!)),
                                                                          const SizedBox(
                                                                              height: 15),
                                                                          Stack(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                height: MediaQuery.of(context).size.height * 0.10,
                                                                                width: MediaQuery.of(context).size.width * 0.60,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Image(image: NetworkImage(selectedProduct!.image!.url!), width: 50, height: 50),
                                                                                  const SizedBox(width: 10),
                                                                                  Column(
                                                                                    children: [
                                                                                      Text(
                                                                                        selectedProduct!.name!,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 2,
                                                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child:
                                                                                SizedBox(
                                                                              height: 50,
                                                                              width: MediaQuery.of(context).size.width / 2,
                                                                              child: ElevatedButton(
                                                                                onPressed: () => {
                                                                                  Navigator.of(context).pushReplacementNamed(''),
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: const Color.fromARGB(255, 47, 171, 148),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(18),
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
                                                                  : const Text(
                                                                      ''),
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
                                                  const Color.fromARGB(
                                                      255, 47, 171, 148),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                            ),
                                            child: const Text(
                                              'Crea terapia',
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
                              );
                            },
                            context: context);

                        /* showModalBottomSheet(
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
                        print(selectedProduct!.name); */
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
