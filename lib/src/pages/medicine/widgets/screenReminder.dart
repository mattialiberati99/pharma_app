import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/pages/medicine/widgets/medicina_terapia.dart';
import 'package:pharma_app/src/providers/terapia_provider.dart';

import '../../../helpers/app_config.dart';
import '../../../models/farmaco.dart';

class ScreenReminder extends ConsumerStatefulWidget {
  Farmaco prodotto;
  String nomeTerapia;
  List<int> giorni;
  String orario;
  String quantita;
  String durata;

  ScreenReminder(this.prodotto, this.nomeTerapia, this.giorni, this.orario,
      this.quantita, this.durata);

  @override
  ConsumerState<ScreenReminder> createState() => _ScreenReminderState();
}

class _ScreenReminderState extends ConsumerState<ScreenReminder> {
  bool noty = true;

  int mese = 30;

  @override
  void initState() {
    // TODO: implement initState
    // terProv = ref.watch()
    //// quantita.text = '1 Compressa';
    giorni();
    super.initState();
  }

  giorni() {
    int oggi = DateTime.now().month;
    switch (oggi) {
      case 1:
        {
          mese = 31;
          break;
        }
      case 2:
        {
          mese = 28;
          break;
        }
      case 3:
        {
          mese = 31;
          break;
        }
      case 4:
        {
          mese = 30;
          break;
        }
      case 5:
        {
          mese = 31;
          break;
        }
      case 6:
        {
          mese = 30;
          break;
        }
      case 7:
        {
          mese = 31;
          break;
        }
      case 8:
        {
          mese = 31;
          break;
        }
      case 9:
        {
          mese = 30;
          break;
        }
      case 10:
        {
          mese = 31;
          break;
        }
      case 11:
        {
          mese = 30;
          break;
        }
      case 12:
        {
          mese = 31;
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leMieMed = ref.read(terapiaProvider);

    return Container(
      color: const Color.fromARGB(255, 249, 249, 249),
      margin: const EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height * 0.95,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Text('Reminder'),
                GestureDetector(
                  onTap: () {},
                  child: noty
                      ? const Image(
                          color: AppColors.gray4,
                          width: 24,
                          height: 24,
                          image: AssetImage(
                              'assets/immagini_pharma/icon_noti.png'))
                      : const Image(
                          color: AppColors.gray4,
                          image: AssetImage('assets/immagini_pharma/bell.png')),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 386,
              height: 198,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Image(
                            width: 124,
                            height: 170,
                            image: NetworkImage(widget.prodotto.image!.url!)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 140, 149, 149),
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.prodotto.name!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Terapia ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 140, 149, 149),
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.nomeTerapia,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Prossima dose ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 140, 149, 149),
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.orario,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Questo mese',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text((widget.giorni.length).toString() + '/' + mese.toString())
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 386,
              height: 260,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (!widget.giorni.contains(1) &&
                                int.parse(widget.durata) -
                                        widget.giorni.length >
                                    0) {
                              setState(() {
                                widget.giorni.add(1);
                                print('funz');
                              });
                            } else {
                              setState(() {
                                widget.giorni.remove(1);
                                print('il max');
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(1)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(2) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(2);
                              } else {
                                widget.giorni.remove(2);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(2)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(3) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(3);
                              } else {
                                widget.giorni.remove(3);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(3)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(4) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(4);
                              } else {
                                widget.giorni.remove(4);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(4)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(5) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(5);
                              } else {
                                widget.giorni.remove(5);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(5)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(6) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(6);
                              } else {
                                widget.giorni.remove(6);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(6)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(7) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(7);
                              } else {
                                widget.giorni.remove(7);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(7)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (!widget.giorni.contains(8) &&
                                int.parse(widget.durata) -
                                        widget.giorni.length >
                                    0) {
                              setState(() {
                                widget.giorni.add(8);
                                print('funz');
                              });
                            } else {
                              setState(() {
                                widget.giorni.remove(8);
                                print('il max');
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(8)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(9) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(9);
                              } else {
                                widget.giorni.remove(9);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(9)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(10) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(10);
                              } else {
                                widget.giorni.remove(10);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(10)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(11) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(11);
                              } else {
                                widget.giorni.remove(11);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(11)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(12) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(12);
                              } else {
                                widget.giorni.remove(12);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(12)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(13) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(13);
                              } else {
                                widget.giorni.remove(13);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(13)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(14) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(14);
                              } else {
                                widget.giorni.remove(14);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(14)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (!widget.giorni.contains(15) &&
                                int.parse(widget.durata) -
                                        widget.giorni.length >
                                    0) {
                              setState(() {
                                widget.giorni.add(15);
                                print('funz');
                              });
                            } else {
                              setState(() {
                                widget.giorni.remove(15);
                                print('il max');
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(15)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(16) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(16);
                              } else {
                                widget.giorni.remove(16);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(16)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(17) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(17);
                              } else {
                                widget.giorni.remove(17);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(17)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(18) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(18);
                              } else {
                                widget.giorni.remove(18);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(18)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(19) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(19);
                              } else {
                                widget.giorni.remove(19);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(19)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(20) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(20);
                              } else {
                                widget.giorni.remove(20);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(20)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(21) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(21);
                              } else {
                                widget.giorni.remove(21);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(21)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (!widget.giorni.contains(22) &&
                                int.parse(widget.durata) -
                                        widget.giorni.length >
                                    0) {
                              setState(() {
                                widget.giorni.add(22);
                                print('funz');
                              });
                            } else {
                              setState(() {
                                widget.giorni.remove(22);
                                print('il max');
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(22)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(23) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(23);
                              } else {
                                widget.giorni.remove(23);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(23)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(24) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(24);
                              } else {
                                widget.giorni.remove(24);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(24)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(25) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(25);
                              } else {
                                widget.giorni.remove(25);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(25)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(26) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(26);
                              } else {
                                widget.giorni.remove(26);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(26)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(27) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(27);
                              } else {
                                widget.giorni.remove(27);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(27)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!widget.giorni.contains(28) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                widget.giorni.add(28);
                              } else {
                                widget.giorni.remove(28);
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: widget.giorni.contains(28)
                                    ? AppColors.primary
                                    : Color.fromARGB(25, 35, 154, 141),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (mese > 28)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 14),
                        child: GestureDetector(
                            onTap: () {
                              if (!widget.giorni.contains(29) &&
                                  int.parse(widget.durata) -
                                          widget.giorni.length >
                                      0) {
                                setState(() {
                                  widget.giorni.add(29);
                                  print('funz');
                                });
                              } else {
                                setState(() {
                                  widget.giorni.remove(29);
                                  print('il max');
                                });
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  color: widget.giorni.contains(29)
                                      ? AppColors.primary
                                      : Color.fromARGB(25, 35, 154, 141),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 14),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!widget.giorni.contains(30) &&
                                    int.parse(widget.durata) -
                                            widget.giorni.length >
                                        0) {
                                  widget.giorni.add(30);
                                } else {
                                  widget.giorni.remove(30);
                                }
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  color: widget.giorni.contains(30)
                                      ? AppColors.primary
                                      : Color.fromARGB(25, 35, 154, 141),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            )),
                      ),
                      if (mese > 30)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 14),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!widget.giorni.contains(31) &&
                                      int.parse(widget.durata) -
                                              widget.giorni.length >
                                          0) {
                                    widget.giorni.add(31);
                                  } else {
                                    widget.giorni.remove(31);
                                  }
                                });
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                    color: widget.giorni.contains(31)
                                        ? AppColors.primary
                                        : const Color.fromARGB(
                                            25, 35, 154, 141),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                              )),
                        ),
                    ]),
                ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Quantità',
              style: TextStyle(
                  color: Color.fromARGB(255, 140, 149, 149), fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 185,
                  height: 38,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray5),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.durata} Compresse',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: 185,
                    height: 38,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (int.parse(widget.durata) - widget.giorni.length > 0)
                          Text(
                            '${int.parse(widget.durata) - widget.giorni.length} Mancanti',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        if (int.parse(widget.durata) - widget.giorni.length ==
                            0)
                          const Text(
                            '0 Mancanti',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                      ],
                    )),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //  Navigator.of(context).pop();
                //    _screenReminder(context, orarioSel, quantita.text, durata.text);
                MedicinaTerapia medicina = MedicinaTerapia(
                    widget.prodotto,
                    widget.nomeTerapia,
                    widget.giorni,
                    widget.durata,
                    widget.quantita,
                    widget.orario);
                if (!leMieMed.exist(medicina)) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.bottomSlide,
                    title: "Errore",
                    desc: "La medicina è già presente nelle terapie!",
                    btnOkOnPress: Navigator.of(context).pop,
                  ).show();
                }
                leMieMed.add(medicina);
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.topSlide,
                  title: "Medicina Aggiunta",
                  desc: "Medicina aggiunta correttamente alle terapie!",
                  btnOkOnPress: () {
                    Navigator.of(context)
                        .pushReplacementNamed('Le Mie Medicine');
                  },
                ).show();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 47, 171, 148),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Aggiungi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
