import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/pages/medicine/widgets/screenReminder.dart';

import '../../../helpers/app_config.dart';
import '../../../providers/notification_provider.dart';

class Screen2Terapie extends ConsumerStatefulWidget {
  Farmaco prodotto;
  String nomeTerapia;

  Screen2Terapie(this.prodotto, this.nomeTerapia);

  @override
  ConsumerState<Screen2Terapie> createState() => _Screen2TerapieState();
}

class _Screen2TerapieState extends ConsumerState<Screen2Terapie> {
  TextEditingController tx = TextEditingController();

  TextEditingController durata = TextEditingController();
  TextEditingController quantita = TextEditingController();

  TextEditingController ora = TextEditingController();
  TextEditingController minuti = TextEditingController();

  String orarioSel = '';

  List<String> orariSt = ['11:00', '14:00', '16:00', '20:00'];

  bool c1 = false;
  bool c2 = false;

  _screenReminder(
      BuildContext ctx, String orario, String quantita, String durata) {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 249, 249, 249),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: ctx,
        builder: (_) => ScreenReminder(
            widget.prodotto, widget.nomeTerapia, [], orario, quantita, durata));
  }

  @override
  void initState() {
    // TODO: implement initState
    // terProv = ref.watch()
    //// quantita.text = '1 Compressa';
    tx.text = widget.prodotto.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProv = ref.watch(notificationProvider);
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height * 0.92,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              Text('Aggiungi il farmaco'),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("Notifiche");
                  notificationProv.nuovaNotifica = false;
                },
                child: notificationProv.nuovaNotifica
                    ? const Image(
                        width: 24,
                        height: 24,
                        image:
                            AssetImage('assets/immagini_pharma/icon_noti.png'))
                    : const Image(
                        color: AppColors.gray4,
                        image: AssetImage('assets/immagini_pharma/bell.png')),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: const [
              Text(
                'Nome della pillola',
                style: TextStyle(
                    color: Color.fromARGB(255, 140, 149, 149), fontSize: 16),
              )
            ],
          ),
          const SizedBox(height: 3),
          TextField(
            onTap: () {},
            controller: tx,
            decoration: const InputDecoration(
                enabled: false,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gray4),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gray4),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gray4),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                //  hintText: 'Cerca prodotto',
                // Barcode
                /*  suffixIcon: SizedBox(
                    child: Image(
                  image: AssetImage('assets/immagini_pharma/barcode.png'),
                )), */
                hintStyle: TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                prefixIcon: Image(
                  image: AssetImage('assets/immagini_pharma/pillola.png'),
                )),
            //  prefixIconColor: Color.fromARGB(255, 167, 166, 165)),
            autofocus: false,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: const [
              Text(
                'Quantità e durata?',
                style: TextStyle(
                    color: Color.fromARGB(255, 140, 149, 149), fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 170,
                child: TextFormField(
                  controller: quantita,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.gray5,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    enabled: true,
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
                    hintText: '1 Compressa',
                    //hintStyle: TextStyles.mediumGrey,
                    filled: true,
                    fillColor: Colors.white,
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
                        child: Image(
                          image:
                              AssetImage('assets/immagini_pharma/pillola.png'),
                        )),
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 40,
                      maxHeight: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 170,
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: durata,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.gray5,
                  decoration: const InputDecoration(
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
                    hintText: '10 Giorni',
                    //hintStyle: TextStyles.mediumGrey,
                    filled: true,
                    fillColor: Colors.white,
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
                          Icons.calendar_month,
                          color: AppColors.gray4,
                        )),
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 40,
                      maxHeight: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Orari',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.gray5)),
                height: 177,
                width: 185,
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                          image:
                              AssetImage('assets/immagini_pharma/pranzi.png')),
                      SizedBox(
                        width: 15,
                      ),
                      Image(
                          image: AssetImage('assets/immagini_pharma/piu.png')),
                      SizedBox(
                        width: 15,
                      ),
                      Image(
                          image:
                              AssetImage('assets/immagini_pharma/piatto.png')),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Prima dei pasti',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          value: c1,
                          onChanged: (newValue) {
                            setState(() {
                              c1 = newValue!;
                              c2 = false;
                            });
                          }),
                    ],
                  )
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.gray5)),
                height: 177,
                width: 185,
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                          image:
                              AssetImage('assets/immagini_pharma/piatto.png')),
                      SizedBox(
                        width: 15,
                      ),
                      Image(
                          image: AssetImage('assets/immagini_pharma/piu.png')),
                      SizedBox(
                        width: 15,
                      ),
                      Image(
                          image:
                              AssetImage('assets/immagini_pharma/pranzi.png')),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Dopo i pasti',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          value: c2,
                          onChanged: (newValue) {
                            setState(() {
                              c2 = newValue!;
                              c1 = false;
                            });
                          }),
                    ],
                  ),
                ]),
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
                'Notifiche',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 386,
            height: 124,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.gray5)),
            child: ListView.separated(
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        if (index != orariSt.length)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                orarioSel = orariSt[index];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 109,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: orarioSel == orariSt[index]
                                      ? AppColors.primary
                                      : Colors.white,
                                  border: Border.all(color: AppColors.gray5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    orariSt[index],
                                    style: TextStyle(
                                        color: orariSt[index] == orarioSel
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (index == orariSt.length)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          backgroundColor: Colors.grey,
                                          content: Container(
                                            height: 200,
                                            width: 200,
                                            child: Column(
                                              children: [
                                                Text('Inserisci un orario!'),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 80,
                                                      height: 30,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        controller: ora,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor:
                                                            AppColors.gray5,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: AppColors
                                                                    .gray5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: AppColors
                                                                  .gray5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: AppColors
                                                                    .gray5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),

                                                          //hintStyle: TextStyles.mediumGrey,
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          /*  suffixIcon: Padding(
                                                                              padding: EdgeInsets.only(left: 16.0),
                                                                              child: Image(
                                                                                  image: AssetImage(
                                                                                      'assets/immagini_pharma/arrdow.png')),
                                                                            ),*/
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(":"),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                      width: 80,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        controller: minuti,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor:
                                                            AppColors.gray5,
                                                        decoration:
                                                            const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(0),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: AppColors
                                                                    .gray5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: AppColors
                                                                  .gray5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: AppColors
                                                                    .gray5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),

                                                          //hintStyle: TextStyles.mediumGrey,
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          /*  suffixIcon: Padding(
                                                                              padding: EdgeInsets.only(left: 16.0),
                                                                              child: Image(
                                                                                  image: AssetImage(
                                                                                      'assets/immagini_pharma/arrdow.png')),
                                                                            ),*/
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                if (ora.text.isEmpty &&
                                                    minuti.text.isEmpty)
                                                  FloatingActionButton(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    onPressed: () {},
                                                    child: const Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                if (ora.text.isNotEmpty &&
                                                    minuti.text.isNotEmpty)
                                                  FloatingActionButton(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        orariSt.add(ora.text +
                                                            ':' +
                                                            minuti.text);
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Ok",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ));
                                //     orariSt.add(orarioSel);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: 109,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 224, 250, 252),
                                    border: Border.all(color: AppColors.gray5)),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: orariSt.length + 1),
          ),
          if (orarioSel.isNotEmpty &&
              (c1 || c2) &&
              quantita.text.isNotEmpty &&
              durata.text.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _screenReminder(context, orarioSel, quantita.text, durata.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 47, 171, 148),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Avanti',
              ),
            ),
          if (orarioSel.isEmpty ||
              (!c1 && !c2) ||
              quantita.text.isEmpty ||
              durata.text.isEmpty)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 47, 171, 148),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Avanti',
              ),
            )
        ]),
      ),
    );
  }
}
