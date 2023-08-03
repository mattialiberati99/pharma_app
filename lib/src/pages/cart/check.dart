import 'package:csc_picker/dropdown_with_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pharma_app/src/pages/cart/cart_page.dart';
import 'package:pharma_app/src/pages/cart/mappa_farmacie.dart';
import 'package:pharma_app/src/pages/orders/widgets/ordinePagato.dart';
import 'package:pharma_app/src/pages/payment_cards/gestisci_carte.dart';
import 'package:pharma_app/src/providers/user_addresses_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../../dialogs/CustomDialog.dart';
import '../../dialogs/order_success_dialog.dart';
import '../../helpers/app_config.dart';
import '../../models/food_order.dart';
import '../../models/order.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';

class Check extends ConsumerStatefulWidget {
  const Check({Key? key}) : super(key: key);

  @override
  ConsumerState<Check> createState() => _CheckState();
}

class _CheckState extends ConsumerState<Check> {
  File? _ricetta;

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

  var ordine = FarmacoOrder();
  List<FarmacoOrder> prodotti = [];
  var ord = Order();

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

  _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _ricetta = File(pickedFile.path);
        });
      }
    });
  }

  _getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'jpeg',
        'jpg',
        'png',
      ],
    );
    if (result != null && result.files.single.path != null) {
      _ricetta = File(result.files.single.path!);
    } else {
      Navigator.of(context).pop();
      print('FILE NULL');
    }
    Navigator.of(context, rootNavigator: true).pop('dialog');
    print(_ricetta!.path);
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    final ordProv = ref.watch(ordersProvider);
    final userAddrProv = ref.watch(userAddressesProvider);
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
              onPressed: () {
                gestisciPagamento();
              },
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
                    '${cartProv.total}€',
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
                                        scd = false;
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
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 45.0),
                          child: Text(
                            'Via Roma, Verona, Italia',
                            style: TextStyle(
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
                                        first = false;
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
                        const SizedBox(
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
                height: 5,
              ),

              _ricetta != null
                  ? ClipRRect(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: const Color.fromARGB(26, 7, 15, 71))),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Image.asset(
                                  'assets/immagini_pharma/file_ricetta.png'),
                              const Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Text(p.basename(_ricetta!.path)),
                            ],
                          )),
                    )
                  : const Text(''),
              const SizedBox(
                height: 15,
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
              const SizedBox(
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
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray5),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.gray5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: const OutlineInputBorder(
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
                                : AppColors.gray4,
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
                            builder: (context, child) {
                              return Theme(
                                  child: child!,
                                  data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                          primary: AppColors.primary,
                                          onPrimary: Colors.black,
                                          onSurface: Colors.grey)));
                            },
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
                                : AppColors.gray4,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          maxWidth: 40,
                          maxHeight: 40,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          builder: (context, child) {
                            return Theme(
                                child: child!,
                                data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                        primary: AppColors.primary,
                                        onPrimary: Colors.black,
                                        onSurface: Colors.grey)));
                          },
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
                            c2 = false;
                            c3 = false;
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
                            c1 = false;
                            c3 = false;
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
                            c1 = false;
                            c2 = false;
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

  void gestisciPagamento() {
    if ((c1 || c2 || c3) && (first || scd)) {
      if (first) {
        if (_ricetta == null) {
          importaRicetta();
        } else {
          if (c1) {
            pagaConCarta();
          }
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             OrdinePagato(dateinput.text, timeinput.text)));
        }
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MappaFarmacie()));
      }
    } else {
      null;
    }
  }

  void importaRicetta() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Center(child: Text("Importa ricetta")),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1.0,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/immagini_pharma/ricetta_dialog.png',
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          const Positioned(
                            top: 40,
                            child: Center(
                              child: SizedBox(
                                width: 220,
                                child: Text(
                                  'Per validare la tua prenotazione allega la ricetta',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          // TODO FINIRE IMPORTAZIONE RICETTE
                          Positioned(
                            top: 160,
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _getDocument();
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 47, 171, 148),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'Allega documento',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 225,
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _getImage(ImageSource.camera);
                                  Navigator.pop(context, _ricetta);
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 107, 107, 107)),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'Scatta una foto',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 107, 107, 107)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void pagaConCarta() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40.0),
        ),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8),
                child: const CarteWidget(),
              ),
            ),
          ),
        );
      },
    );
  }
}

finalizeOrder(CartProvider cartProv, OrdersProvider orderProv,
    BuildContext context) async {
  List<Order>? orders = await cartProv.proceedOrder(context);
  if (orders != null && context.mounted) {
    orderProv.orders.insertAll(0, orders);
    cartProv.carts.clear();
    showDialog(
        context: context,
        builder: (context) =>
            OrderSuccessDialog(currentOrder: orders.first.id ?? '#'));
  }
}
