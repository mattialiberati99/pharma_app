import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../helpers/app_config.dart';
import '../../providers/cart_provider.dart';

class Check extends ConsumerStatefulWidget {
  final double prOrd;
  const Check({Key? key, required this.prOrd}) : super(key: key);

  @override
  ConsumerState<Check> createState() => _CheckState();
}

class _CheckState extends ConsumerState<Check> {
  var selectedOne = 0;
  bool first = false;
  bool scd = false;
  bool c1 = false;
  bool c2 = false;
  bool c3 = false;

  String mese = '';
  @override
  initState() {
    super.initState();
    _mese();
  }

  _mese() {
    var mese = DateTime.now().month;
    switch (mese) {
      case 1:
        {
          this.mese = 'Gennaio';
          break;
        }
      case 2:
        {
          this.mese = 'Febbraio';
          break;
        }
      case 3:
        {
          this.mese = 'Marzo';
          break;
        }
      case 4:
        {
          this.mese = 'Aprile';
          break;
        }
      case 5:
        {
          this.mese = 'Maggio';
          break;
        }
      case 6:
        {
          this.mese = 'Giugno';
          break;
        }
      case 7:
        {
          this.mese = 'Luglio';
          break;
        }
      case 8:
        {
          this.mese = 'Agosto';
          break;
        }
      case 9:
        {
          this.mese = 'Settembre';
          break;
        }
      case 10:
        {
          this.mese = 'Ottobre';
          break;
        }
      case 11:
        {
          this.mese = 'Novembre';
          break;
        }
      case 12:
        {
          this.mese = 'Dicembre';
          break;
        }
    }
  }

  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  late DateTime data;
  late TimeOfDay time;
  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    return Scaffold(
      bottomSheet: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(135, 50),
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)))),
              child: const Text(
                'Paga',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xFF333333),
                  ),
                  const Text(
                    'Carrello',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('Cart');
                    },
                    child: const Image(
                        image:
                            AssetImage('assets/immagini_pharma/Icon_shop.png')),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  cartProv.carts.length.toString() + ' articoli nel carrello',
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(115, 9, 15, 71)),
                ),
                const Text(
                  'Totale',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(115, 9, 15, 71)),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.prOrd.toString() + '€',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 9, 15, 71),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Indirizzo di consegna',
                    style: TextStyle(
                        color: Color.fromARGB(255, 9, 15, 71),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //prendere indirizzi e mostrarli cosi
              const SizedBox(
                height: 15,
              ),
              ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Color.fromARGB(26, 7, 15, 71))),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    value: first,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedOne = 0;
                                        first = newValue!;
                                      });
                                    }),
                                const Text(
                                  'Casa',
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
                        const Padding(
                          padding: EdgeInsets.only(left: 45.0),
                          child: Text(
                            '1223234234',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(115, 9, 15, 71)),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 45.0),
                          child: Text(
                            'Via Roma, Verona, Italia',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(115, 9, 15, 71)),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //ind reale dal backEnd
              ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Color.fromARGB(26, 7, 15, 71))),
                  alignment: Alignment.center,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    value: scd,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedOne = 1;
                                        scd = newValue!;
                                      });
                                    }),
                                const Text(
                                  'Salta la fila e ritira in farmacia',
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
                        const Padding(
                          padding: EdgeInsets.only(left: 45.0),
                          child: Text(
                            '3232343456',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(115, 9, 15, 71)),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 45.0),
                          child: Text(
                            'Via Dalmazia, Bergamo, Italia',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(115, 9, 15, 71)),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Aggiungi indirizzo'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Seleziona la data di consegna',
                    style: TextStyle(
                        color: Color.fromARGB(255, 9, 15, 71),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 170,
                    child: TextFormField(
                      controller: dateinput,
                      cursorColor: AppColors.gray5,
                      style: TextStyle(
                        color: dateinput.text.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.gray5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: mese,
                        //hintStyle: TextStyles.mediumGrey,
                        filled: true,
                        fillColor: dateinput.text.isNotEmpty
                            ? AppColors.primary
                            : Colors.white,
                        /*  suffixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/arrdow.png')),
                        ),*/
                        prefix: SizedBox(
                          width: 16,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.calendar_today,
                            color: dateinput.text.isNotEmpty
                                ? Colors.white
                                : AppColors.gray7,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 40,
                          maxHeight: 40,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 2)),
                            firstDate: DateTime.now(),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          setState(() {
                            data = pickedDate;
                            dateinput.text =
                                DateFormat('dd/MM/yy').format(data);
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 170,
                    child: TextFormField(
                      style: TextStyle(
                        color: timeinput.text.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                      ),
                      controller: timeinput,
                      cursorColor: AppColors.gray5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.gray5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: 'Orario',
                        //hintStyle: TextStyles.mediumGrey,
                        filled: true,
                        fillColor: timeinput.text.isNotEmpty
                            ? AppColors.primary
                            : Colors.white,
                        /*  suffixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/arrdow.png')),
                        ),*/
                        prefix: SizedBox(
                          width: 16,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(
                            Icons.alarm,
                            color: timeinput.text.isNotEmpty
                                ? Colors.white
                                : AppColors.gray7,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 40,
                          maxHeight: 40,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        //DateTime.now() - not to allow to choose before today.

                        if (pickedTime != null) {
                          setState(() {
                            time = pickedTime;
                            timeinput.text = '${time.hour} : ${time.minute}';
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Metodo di pagamento',
                    style: TextStyle(
                        color: Color.fromARGB(255, 9, 15, 71),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Aggiungi carta'),
                  ),
                ],
              ),
              Container(
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.gray6,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        value: c1,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOne = 0;
                            c1 = newValue!;
                          });
                        }),
                    const Text(
                      'Credit Card',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.gray6,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        value: c2,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOne = 0;
                            c2 = newValue!;
                          });
                        }),
                    const Text(
                      'PayPal',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.gray6,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        value: c3,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOne = 0;
                            c3 = newValue!;
                          });
                        }),
                    const Text(
                      'Contanti',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
