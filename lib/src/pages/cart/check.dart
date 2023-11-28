import 'package:csc_picker/dropdown_with_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/address.dart';
import 'package:pharma_app/src/pages/cart/cart_page.dart';
import 'package:pharma_app/src/pages/orders/widgets/ordinePagato.dart';
import 'package:pharma_app/src/pages/payment_cards/gestisci_carte.dart';
import 'package:pharma_app/src/providers/addresses_provider.dart';
import 'package:pharma_app/src/providers/user_addresses_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../../components/shadow_box.dart';
import '../../dialogs/CustomDialog.dart';
import '../../dialogs/order_success_dialog.dart';
import '../../helpers/app_config.dart';
import '../../helpers/helper.dart';
import '../../models/chat.dart';
import '../../models/food_order.dart';
import '../../models/order.dart';
import '../../models/route_argument.dart';
import '../../providers/acquistiRecenti_provider.dart';
import '../../providers/can_add_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/shops_provider.dart';
import '../home/home.dart';

class Check extends ConsumerStatefulWidget {
  const Check({Key? key}) : super(key: key);

  static late DateTime data;
  static late TimeOfDay time;

  @override
  ConsumerState<Check> createState() => _CheckState();
}

class _CheckState extends ConsumerState<Check> {
  //File? _ricetta;
  String my_address = '';
  String address_number = '';

  var selectedOne = 0;
  bool first = false;
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

// RICETTA MEDICA
/*   _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _ricetta = File(pickedFile.path);
        });
      }
    });
  } */

/*   _getDocument() async {
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
  } */

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.watch(cartProvider);
    final ordProv = ref.watch(ordersProvider);
    final addrProv = ref.watch(addressesProvider);
    final acquistiRecentiProv = ref.watch(acquistiRecentiProvider);

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
                gestisciPagamento(
                    cartProv, ordProv, addrProv, acquistiRecentiProv);
              },
            ),
          ],
        ),
      ),
      body: cartProv.deliveryAddress == null
          ? Center(child: const CircularProgressIndicator())
          : Padding(
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('Cart');
                          },
                          child: const Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/Icon_shop.png')),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cartProv.carts.length.toString() +
                                ' articoli nel carrello',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(115, 9, 15, 71)),
                          ),
                          const Text(
                            'Totale',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(115, 9, 15, 71)),
                          ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(cartProv.veroTotale).toStringAsFixed(2)}€',
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: Color.fromARGB(26, 7, 15, 71))),
                        alignment: Alignment.center,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        'Indirizzo',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 9, 15, 71),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        scegliIndirizzo(context, addrProv);
                                      },
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
                              Padding(
                                padding: EdgeInsets.only(left: 45.0),
                                child: Text(
                                  address_number,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(115, 9, 15, 71),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 45.0),
                                child: Text(
                                  my_address == ''
                                      ? 'Seleziona un indirizzo!'
                                      : my_address,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            aggiungiIndirizzo(addrProv);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Aggiungi indirizzo'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    /*  _ricetta != null
                  ? ClipRRect(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: const Color.fromARGB(26, 7, 15, 71))),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Image.asset(
                                  'assets/immagini_pharma/file_ricetta.png',
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                Text(
                                  p.basename(_ricetta!.path),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )),
                    )
                  : const Text(''), */
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.gray5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                  initialDate: DateTime.now()
                                      .add(const Duration(days: 2)),
                                  firstDate: DateTime.now(),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                setState(() {
                                  Check.data = pickedDate;
                                  dateinput.text =
                                      DateFormat('dd/MM/yy').format(Check.data);
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
                          width: 41.w,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.gray5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                  Check.time = pickedTime;
                                  timeinput.text =
                                      '${Check.time.hour} : ${Check.time.minute}';
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Metodo di pagamento',
                          style: TextStyle(
                              color: Color.fromARGB(255, 9, 15, 71),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        /*     TextButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context, builder: (_) => CarteWidget());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Aggiungi carta'),
                  ), */
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 74,
                      decoration: BoxDecoration(
                        color: AppColors.gray6,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/immagini_pharma/icon_visa.png',
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                              'assets/immagini_pharma/icon_master_card.png'),
                          const SizedBox(width: 10),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          ),
                          const Spacer(),
                          Image.asset('assets/immagini_pharma/icon_paypal.png'),
                          const SizedBox(width: 10),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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

  void gestisciPagamento(cartProv, ordProv, addrProv, acquistiRecentiProv) {
    if (my_address != '') {
      if ((c1 || c2 || c3) && first) {
        if (dateinput.text != '' && timeinput.text != '') {
          if (cartProv.deliveryAddress == null) {
            scegliIndirizzo(context, addrProv);
          } else if (cartProv.deliveryAddress != null) {
            if (c1) {
              pagaConCarta();
            } else if (c2) {
              Navigator.of(context).pushReplacementNamed('PayPal');
            } else if (c3) {
              pagaContanti(cartProv, ordProv, acquistiRecentiProv, context);
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Seleziona la data di consegna!"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Seleziona tutti i campi per procedere al pagamento!"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Seleziona un indirizzo di consegna per poter continuare!"),
        ),
      );
    }
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
        return Container(
          // Wrap with a Container
          child: ClipRRect(
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
          ),
        );
      },
    );
  }

  void pagaContanti(CartProvider cartProv, OrdersProvider ordProv,
      AcquistiRecentiProvider acquistiRecentiProv, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Conferma Acquisto in Contanti'),
            content:
                Text('Sei sicuro di voler confermare l\'acquisto in contati?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Annulla'),
              ),
              TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  List<Order>? orders =
                      await cartProv.proceedOrder(context, 'Contanti');
                  Navigator.of(context).pop();

                  if (orders != null) {
                    // logger.info(orders.asMap());
                    ordProv.orders.insertAll(0, orders);

                    // aggiunta ordini recenti
                    for (int i = 0; i < orders.length; i++) {
                      acquistiRecentiProv.saveAcquistiRecenti(
                          orders[i].foodOrders[i].product!);
                    }

                    // Creo chat con negozio
                    final chatProv = ref.watch(chatProvider);

                    logger.info(cartProv.carts[0].product!.restaurant!.id);

                    Chat? chat = await chatProv.getChatWithUser(
                        cartProv.carts[0].product!.restaurant!.id);

                    if (chat != null && chatProv.chats.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Creata chat con il negozio!"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Errore nella creazione della chat!")));
                      logger.error('ERRORE CREAZIONE CHAT');
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrdinePagato(Check.data, Check.time),
                      ),
                    );
                  }
                },
                child: Text('Conferma'),
              ),
            ],
          );
        });
  }

  void aggiungiIndirizzo(addrProv) async {
    TextEditingController _nomeIndirizzoController = TextEditingController();
    TextEditingController _numeroIndirizzoController = TextEditingController();
    TextEditingController _addressIndirizzoController = TextEditingController();
    bool isSaving = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Aggiungi indirizzo',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: _nomeIndirizzoController,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration:
                        InputDecoration(labelText: 'Numero di telefono'),
                    controller: _numeroIndirizzoController,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Indirizzo'),
                    controller: _addressIndirizzoController,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            setState(() {
                              isSaving = true;
                            });
                            await saveIndirizzo(
                                _nomeIndirizzoController.text,
                                _numeroIndirizzoController.text,
                                _addressIndirizzoController.text,
                                addrProv);
                            setState(() {
                              isSaving = false;
                            });
                            Navigator.of(context)
                                .pop(); // Chiudi il bottom sheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Indirizzo salvato con successo: clicca sulla matita per modificare il tuo indirizzo corrente"),
                              ),
                            );
                          },
                    child: isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Conferma'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> saveIndirizzo(String nome, String numero, String indirizzo,
      AddressesProvider addrProv) async {
    Address address = Address();
    address.id = nome;
    address.description = nome;
    address.phone = numero;
    address.address = indirizzo;

    final coordinates = await getLatLongFromAddress(indirizzo);
    if (coordinates['latitude'] != 0.0 && coordinates['longitude'] != 0.0) {
      address.latitude = coordinates['latitude'];
      address.longitude = coordinates['longitude'];
    }

    logger.info('DESC dentro saveIndirizzo: ${address.description}');
    addrProv.addAddress(address);
  }

  Future<Map<String, double>> getLatLongFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        return {
          'latitude': location.latitude,
          'longitude': location.longitude,
        };
      }
      throw Exception('No location found for the given address');
    } catch (e) {
      logger.error('Errore con geocoding: $e');
      return {
        'latitude': 0.0,
        'longitude': 0.0,
      };
    }
  }

  scegliIndirizzo(BuildContext context, AddressesProvider addrProv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return FutureBuilder(
          future: addrProv.loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Data is loaded, display the list of addresses.
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Scegli l\'indirizzo da utilizzare',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addrProv.addresses.length,
                    itemBuilder: (context, index) {
                      final indirizzo = addrProv.addresses[index];
                      logger.info(indirizzo.toMap());
                      return Dismissible(
                        key: ValueKey(indirizzo.id),
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          // Elimina indirizzo
                          addrProv.removeAddress(indirizzo);
                          addrProv.addresses.remove(indirizzo);
                        },
                        child: ListTile(
                          title: Text(indirizzo.address!),
                          onTap: () {
                            // Cambia indirizzo

                            setState(() {
                              my_address = indirizzo.address!;
                              indirizzo.phone != null
                                  ? address_number = indirizzo.phone!
                                  : address_number = '';
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Future<bool?> showConfirmDialog(
    BuildContext context, {
    String? title,
    String? subTitle,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title ?? context.loc.dialog_title,
            textAlign: TextAlign.center,
          ),
          content: Text(
            subTitle ?? context.loc.dialog_subtitle_address,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmText ?? context.loc.dialog_delete,
                textAlign: TextAlign.center,
                style: context.textTheme.subtitle2
                    ?.copyWith(color: context.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText ?? context.loc.dialog_cancel,
                  style: context.textTheme.subtitle2
                      ?.copyWith(color: context.colorScheme.secondary)),
            ),
          ],
        );
      },
    );
  }
}

Future<void> finalizeOrder(
    CartProvider cartProv,
    OrdersProvider orderProv,
    AcquistiRecentiProvider acquistiRecentiProv,
    ChatProvider chatProv,
    BuildContext context,
    String method) async {
  List<Order>? orders = await cartProv.proceedOrder(context, method);
  if (orders != null && context.mounted) {
    Navigator.of(context).pop();
    if (orders.isNotEmpty) {
      logger.info('ORDER IN FINALIZEORDER:');
      logger.info(orders.asMap());
      orderProv.orders.insertAll(0, orders);
      logger.info(
          'ID DELIVERY: ${cartProv.deliveryAddress!.id}, ADDR: ${cartProv.deliveryAddress!.address}, DESC: ${cartProv.deliveryAddress!.description}');

      // TODO: FIX aggiunta ordini recenti

      /*   for (int i = 0; i < orders.length; i++) {
        acquistiRecentiProv
            .saveAcquistiRecenti(orders[i].foodOrders[i].product!);
      } */

      // Creo chat con negozio

      logger.info(cartProv.carts[0].product!.restaurant!.id);

      Chat? chat = await chatProv
          .getChatWithUser(cartProv.carts[0].product!.restaurant!.id);

      if (chat != null && chatProv.chats.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Creata chat con il negozio!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Errore nella creazione della chat!")));
        logger.error('ERRORE CREAZIONE CHAT');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrdinePagato(Check.data, Check.time),
        ),
      );
/*     showDialog(
        context: context,
        builder: (context) =>
            OrderSuccessDialog(currentOrder: ordders.first.id ?? '#')); */
    }
  }
}
