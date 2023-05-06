import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../components/main_app_bar.dart';
import '../../components/search_bar/shop_search_bar.dart';
import '../../models/farmaco.dart';

class ArmadiettoScreen extends StatefulWidget {
  final List<Farmaco> leMieMedicine;

  ArmadiettoScreen(this.leMieMedicine);

  @override
  State<ArmadiettoScreen> createState() => _ArmadiettoScreenState();
}

class _ArmadiettoScreenState extends State<ArmadiettoScreen> {
  final _searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    if (widget.leMieMedicine.isEmpty) {
      return Scaffold(
        body: Container(
          padding: new EdgeInsets.all(26),
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                'Farmaci Validi',
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
                                  const SearchBarShop(),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ricerce recenti',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Reset',
                                          style: TextStyle(color: Colors.red),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => print('ciao'),
                                        ),
                                      ),
                                    ],
                                  )
                                  // ElevatedButton(
                                  //   child: const Text('Close BottomSheet'),
                                  //   onPressed: () => Navigator.pop(context),
                                  // ),
                                ],
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
                        'Aggiungi farmaco',
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
      return ListView.builder(
          itemCount: widget.leMieMedicine.length,
          itemBuilder: (context, index) {});
    }
  }
}
