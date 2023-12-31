import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/search_bar/search_bar_routine.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/medicine/widgets/medicina_routine.dart';
import 'package:pharma_app/src/pages/medicine/widgets/screen2routine.dart';
import 'package:pharma_app/src/providers/routine_provider.dart';

import '../../../generated/l10n.dart';
import '../../components/drawer/app_drawer.dart';
import '../../components/meds_app_bar.dart';
import '../../components/bottomNavigation.dart';
import '../../components/search_bar/shop_search_bar.dart';
import '../../helpers/app_config.dart';
import '../../models/farmaco.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  List<Farmaco> leMieRoutine = [];
  final tx = TextEditingController(text: '');
  Farmaco? selectedProduct;
  String nomeRoutine = '';

  @override
  void initState() {
    super.initState();
  }

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
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.92,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Text('Aggiungi il farmaco'),
                  const SizedBox(height: 20),
                  SearchBarRoutine(callback: selectProduct),
                  const SizedBox(height: 20),
                  selectedProduct != null
                      ? Center(
                          child: Column(
                            children: [
                              Image(
                                image:
                                    NetworkImage(selectedProduct!.image!.url!),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        // Wrap the Text widget in an Expanded widget
                                        child: Column(
                                          children: [
                                            Text(
                                              selectedProduct != null
                                                  ? selectedProduct!.name!
                                                  : '',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
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
                                      _screenRoutine(context, selectedProduct!);
                                      //   Navigator.of(context)
                                      //  .pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 47, 171, 148),
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
                ],
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        selectedProduct = null;
      });
    });
  }

  _screenRoutine(BuildContext ctx, Farmaco prodotto) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: ctx,
        builder: (_) => Screen2Routine(prodotto, nomeRoutine));
  }

  @override
  Widget build(BuildContext context) {
    final leMieMed = ref.watch(routineProvider);
    FlutterNativeSplash.remove();

    if (leMieMed.isEmpty()) {
      return Scaffold(
        body: ListView(
          children: [
            Container(
              padding: new EdgeInsets.all(26),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'Le mie routine',
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
                            /*  Noti().showRoutineNotification(
                                title: 'Prova', body: 'Funge'); */
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
                                          MediaQuery.of(context).size.height /
                                              2.5,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Aggiungi un nome alla routine:',
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
                                                    nomeRoutine = tx.text;
                                                  });
                                                },
                                                onSaved: (value) {
                                                  if (tx.text.isNotEmpty) {
                                                    setState(() {
                                                      nomeRoutine = tx.text;
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
                                                decoration:
                                                    const InputDecoration(
                                                  enabled: true,
                                                  filled: true,
                                                  fillColor: AppColors.gray6,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8,
                                                          horizontal: 16),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  AppColors
                                                                      .gray4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  AppColors
                                                                      .gray4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: AppColors
                                                                      .gray4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  hintText: 'Nome Routine',
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
                                                    if (nomeRoutine
                                                        .isNotEmpty) {
                                                      print(tx.text);
                                                      Navigator.of(context)
                                                          .pop();
                                                      _screenUno(context);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Inserisci nome routine"),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 47, 171, 148),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Crea Routine',
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
                            'Aggiungi routine',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
              'Le mie routine',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: leMieMed.length,
              itemBuilder: (ctx, i) => leMieMed.routine[i],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('TERAPIE');

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
                                    'Aggiungi un nome alla routine:',
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
                                          nomeRoutine = tx.text;
                                        });
                                      },
                                      onSaved: (value) {
                                        if (tx.text.isNotEmpty) {
                                          setState(() {
                                            nomeRoutine = tx.text;
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
                                        hintText: 'Nome Routine',
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
                                    child: nomeRoutine.isNotEmpty
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
                                              'Crea Routine',
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
                                              'Crea Routine',
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
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
                    'Aggiungi routine',
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
