/* import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class IndirizzoConsegnaTile extends ConsumerWidget {
  final String nome;
  final String numero;
  final String indirizzo;
  bool selected = false;

  IndirizzoConsegnaTile({
    Key? key,
    required this.nome,
    required this.numero,
    required this.indirizzo,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    value: selected,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedOne = 1;
                                        scd = newValue!;
                                        first = false;
                                      });
                                    }),
                                const Text(
                                  'Salta la fila e ritira in restaurant',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 9, 15, 71),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Image(
                                    image: AssetImage(
                                        'assets/immagini_pharma/mod.png')),
                              ),
                            )
                          ],
                        ),
  }
}
 */