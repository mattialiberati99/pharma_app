import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/search_bar/search_bar_terapie.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/medicine/widgets/medicineTerapia.dart';
import 'package:pharma_app/src/pages/medicine/widgets/screen2terapie.dart';
import 'package:pharma_app/src/providers/terapia_provider.dart';

import '../../components/drawer/app_drawer.dart';
import '../../components/meds_app_bar.dart';
import '../../components/bottomNavigation.dart';
import '../../components/search_bar/shop_search_bar.dart';
import '../../helpers/app_config.dart';
import '../../models/farmaco.dart';

class TerapieScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TerapieScreen> createState() => _TerapieScreenState();
}

class _TerapieScreenState extends ConsumerState<TerapieScreen> {
  List<Farmaco> leMieTerapie = [];
  final tx = TextEditingController(text: '');
  Farmaco? selectedProduct;
  String nomeTerapia = '';

  void selectProduct(Farmaco selectedProduct) {
    setState(() {
      this.selectedProduct = selectedProduct;
    });
  }

  _screenUno(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.92,
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
                              image:
                                  NetworkImage(selectedProduct!.image!.url!)),
                          // const SizedBox(height: 15),

                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      image: NetworkImage(
                                          selectedProduct!.image!.url!),
                                      width: 50,
                                      height: 50),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(
                                        selectedProduct!.name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _screenTerapia(context, selectedProduct!);
                                  //   Navigator.of(context)
                                  //  .pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 47, 171, 148),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'Avanti',
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
  }

  _screenTerapia(BuildContext ctx, Farmaco prodotto) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: ctx,
        builder: (_) => Screen2Terapie(prodotto, nomeTerapia));
  }

  @override
  Widget build(BuildContext context) {
    final leMieMed = ref.watch(terapiaProvider).terapie;
    FlutterNativeSplash.remove();
    if (leMieMed.isEmpty) {
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
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  margin: EdgeInsets.only(top: 60),
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Aggiungi un nome alla terapia:',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 314,
                                          height: 40,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                nomeTerapia = tx.text;
                                              });
                                            },
                                            onSaved: (value) {
                                              if (tx.text.isNotEmpty) {
                                                setState(() {
                                                  nomeTerapia = tx.text;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (tx.text.isNotEmpty) {
                                                return tx.text;
                                              }
                                              return null;
                                            },
                                            controller: tx,
                                            decoration: const InputDecoration(
                                              enabled: true,
                                              filled: true,
                                              fillColor: AppColors.gray6,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors.gray4),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors.gray4),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              AppColors.gray4),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              hintText: 'Nome Terapia',
                                              hintStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 182, 184, 183)),
                                            ),
                                            //  prefixIconColor: Color.fromARGB(255, 167, 166, 165)),
                                            autofocus: false,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 80,
                                        ),
                                        SizedBox(
                                            height: 50,
                                            width: 246,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (nomeTerapia.isNotEmpty) {
                                                  Navigator.of(context).pop();
                                                  _screenUno(context);
                                                  //   Navigator.of(context)
                                                  //  .pop();
                                                } else {
                                                  null;
                                                }
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
                                                'Crea Terapia',
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Annulla'),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
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
      return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Le mie terapie',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: leMieMed.length,
              itemBuilder: (ctx, i) => leMieMed[i],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                            margin: EdgeInsets.only(top: 60),
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Aggiungi un nome alla terapia:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 314,
                                    height: 40,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          nomeTerapia = tx.text;
                                        });
                                      },
                                      onSaved: (value) {
                                        if (tx.text.isNotEmpty) {
                                          setState(() {
                                            nomeTerapia = tx.text;
                                          });
                                        }
                                      },
                                      validator: (value) {
                                        if (tx.text.isNotEmpty) {
                                          return tx.text;
                                        }
                                        return null;
                                      },
                                      controller: tx,
                                      decoration: const InputDecoration(
                                        enabled: true,
                                        filled: true,
                                        fillColor: AppColors.gray6,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.gray4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.gray4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.gray4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText: 'Nome Terapia',
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 182, 184, 183)),
                                      ),
                                      //  prefixIconColor: Color.fromARGB(255, 167, 166, 165)),
                                      autofocus: false,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 246,
                                    child: nomeTerapia.isNotEmpty
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _screenUno(context);
                                              //   Navigator.of(context)
                                              //  .pop();
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
                                              'Crea Terapia',
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () {},
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
                                              'Crea Terapia',
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Annulla'),
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 47, 171, 148),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Aggiungi terapia',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
