import 'package:pharma_app/src/providers/armadietto_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pharma_app/src/pages/medicine/widgets/medicina_armadietto.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../helpers/app_config.dart';
import '../../models/farmaco.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  final Farmaco product;

  const ReminderScreen({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  TextEditingController dateinput = TextEditingController();

  late DateTime dataReminder;

  @override
  Widget build(BuildContext context) {
    final leMieMedicine = ref.read(armadiettoProvider);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(249, 249, 249, 249),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(249, 249, 249, 249),
        elevation: 0,
        title: Transform(
          transform: Matrix4.translationValues(80.0, 0.0, 0.0),
          child: const Text('Reminder', style: TextStyle(color: Colors.black)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          //alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 15, right: 15),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    width: 150.00,
                    height: 200.00,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.product.image!.url!),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nome',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.farmacia!.name!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        widget.product.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: const Text(
                  'Seleziona la data di scadenza',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 200,
                child: TextFormField(
                  controller: dateinput,
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
                    hintText: '__ /__ /__',
                    //hintStyle: TextStyles.mediumGrey,
                    filled: true,
                    fillColor: Colors.white,
                    prefix: SizedBox(
                      width: 16,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.date_range),
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
                        dataReminder = pickedDate;
                        dateinput.text =
                            DateFormat('dd/MM/yy').format(dataReminder);
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: const Text(
                  'Aggiungi una nota',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(244, 246, 245, 245),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                child: const TextField(
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Es. La medicina è nel mobiletto in cucina',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 210,
                    child: ElevatedButton(
                      onPressed: () {
                        MedicinaArmadietto medicina =
                            MedicinaArmadietto(widget.product, dataReminder);
                        if (!leMieMedicine.exist(medicina)) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            title: "Errore",
                            desc: "La medicina è già presente nell'armadio!",
                            btnOkOnPress: Navigator.of(context).pop,
                          ).show();
                        }
                        leMieMedicine.add(medicina);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          title: "Medicina Aggiunta",
                          desc:
                              "Medicina aggiunta correttamente all'armadietto!",
                          btnOkOnPress: () {
                            Navigator.of(context)
                                .pushReplacementNamed('Le Mie Medicine');
                          },
                        ).show();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 47, 171, 148),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Aggiungi',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
