import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/helpers/validators.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pharma_app/src/models/media.dart';
import 'package:sizer/sizer.dart';
import '../../components/social_login_row.dart';
import '../../providers/user_provider.dart';

import '../../helpers/app_config.dart';
import '../../models/address.dart';
import '../../providers/position_provider.dart';

class PreSignUp extends ConsumerStatefulWidget {
  const PreSignUp({super.key});

  @override
  ConsumerState<PreSignUp> createState() => _PreSignUpState();
}

class _PreSignUpState extends ConsumerState<PreSignUp> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController posizione = TextEditingController();
  late DateTime data;

  final _formKey = GlobalKey<FormState>();
  var userSex = 0;
  var _userDay = '';
  var _userMonth = '';
  var _userYear = '';
  var _userPosition = '';

  bool getD = false;
  bool getM = false;
  bool getY = false;
  bool getP = false;

  void _trySubmit(context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      //salvo i dati
      Navigator.of(context).pushReplacementNamed('SignUp');
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final posProv = ref.watch(positionProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: const Image(
                    width: 33,
                    height: 32,
                    image: AssetImage('assets/immagini_pharma/logo_small.png'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: const Text(
                    "Parliamo un po' di te",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'Il tuo genere',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 239, 242, 241),
                              ),
                              height: 99,
                              width: 173,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: userSex == 0
                                          ? Color.fromARGB(255, 47, 161, 148)
                                          : Colors.white,
                                    ),
                                    width: 15.w,
                                    height: 7.h,
                                    child: const Image(
                                        color: Colors.black,
                                        image: AssetImage(
                                            'assets/immagini_pharma/icon_male.png')),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if (userSex == 0)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 239, 242, 241),
                                        disabledForegroundColor:
                                            Color.fromARGB(255, 239, 242, 241),
                                        disabledBackgroundColor:
                                            Color.fromARGB(255, 239, 242, 241),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          userSex = 0;
                                        });
                                      },
                                      child: const Text(
                                        'Maschio',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 47, 161, 148)),
                                      ),
                                    ),
                                  if (userSex == 1)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 239, 242, 241),
                                        disabledForegroundColor:
                                            Color.fromARGB(255, 239, 242, 241),
                                        disabledBackgroundColor:
                                            Color.fromARGB(255, 239, 242, 241),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          userSex = 0;
                                        });
                                      },
                                      child: const Text(
                                        'Maschio',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(left: 5),
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 239, 242, 241),
                                ),
                                height: 99,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: userSex == 1
                                            ? const Color.fromARGB(
                                                255, 47, 161, 148)
                                            : Colors.white,
                                      ),
                                      width: 15.w,
                                      height: 7.h,
                                      child: const Image(
                                          image: AssetImage(
                                              'assets/immagini_pharma/icon_female.png')),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    if (userSex == 1)
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color.fromARGB(
                                              255, 239, 242, 241),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            userSex = 1;
                                          });
                                        },
                                        child: const Text(
                                          'Femmina',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 47, 161, 148)),
                                        ),
                                      ),
                                    if (userSex == 0)
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color.fromARGB(
                                              255, 239, 242, 241),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            userSex = 1;
                                          });
                                        },
                                        child: const Text(
                                          'Femmina',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.width * 0.64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 22),
                          child: const Text(
                            'Il tuo compleanno',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: dateinput,
                              cursorColor: AppColors.gray5,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.gray5),
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
                                  borderSide:
                                      BorderSide(color: AppColors.gray5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintText: '__ /__ /__',
                                //hintStyle: TextStyles.mediumGrey,
                                filled: true,
                                fillColor: AppColors.gray6,
                                prefix: SizedBox(
                                  width: 16,
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Icon(Icons.alarm),
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
                                    initialDate: new DateTime.now(),
                                    firstDate: new DateTime(1900),
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
                        ),
                        const SizedBox(
                          height: 5,
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: const Text(
                                'La tua posizione',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: SizedBox(
                                width: 300,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: TextFormField(
                                    controller: posizione,
                                    textInputAction: TextInputAction.next,
                                    onTap: () {
                                      posProv.suggestion = null;
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        currentUser.value.address =
                                            posizione.text;
                                      });
                                    },
                                    onChanged: (val) async {
                                      if (val.length > 3) {
                                        posProv.searchAddress(
                                            address: posizione.text);
                                      }
                                    },
                                    cursorColor: AppColors.gray5,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.gray5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.gray5,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.gray5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: 'Luogo di partenza',
                                      //hintStyle: TextStyles.mediumGrey,
                                      filled: true,
                                      fillColor: AppColors.gray6,
                                      prefix: SizedBox(
                                        width: 16,
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Icon(Icons.accessibility),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        maxWidth: 40,
                                        maxHeight: 40,
                                      ),
                                    ),
                                  ),
                                  subtitle: (posProv.suggestion != null)
                                      ? Container(
                                          child: GestureDetector(
                                            onTap: () async {
                                              posizione.text =
                                                  posProv.suggestion!;
                                              Address newAddress =
                                                  Address.fromJSON({});
                                              newAddress.address =
                                                  posProv.suggestion!;
                                              var position =
                                                  await GeocodingPlatform
                                                      .instance
                                                      .locationFromAddress(
                                                          newAddress.address!);
                                              newAddress.latitude =
                                                  position.first.latitude;
                                              newAddress.longitude =
                                                  position.first.longitude;
                                              //shipping.from = newAddress;

                                              setState(() {
                                                posProv.suggestion = null;
                                              });
                                              FocusScope.of(context)
                                                  .nextFocus();
                                            },
                                            child: Card(
                                              color: AppColors.primary,
                                              elevation: 6,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Flex(
                                                  direction: Axis.horizontal,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: AutoSizeText(
                                                          "${posProv.suggestion}",
                                                          maxLines: 1,
                                                          //overflow: TextOverflow.fade,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                    const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            /* SizedBox(
                              height: getP ? 44 : 64,
                              child: Row(
                                children: [
                                  Container(
                                      margin:
                                          const EdgeInsets.only(left: 4),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      width: 360,
                                      child: TextFormField(
                                        onSaved: ((newValue) {
                                          print(newValue);
                                          _userPosition = newValue!;
                                        }),
                                        key: const ValueKey('Posizione'),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 10) {
                                            setState(() {
                                              getP = true;
                                            });
                                            return "Inserire una posizione corretta";
                                          } else {
                                            setState(() {
                                              getP = false;
                                            });
                                            return null;
                                          }
                                        },
                                        style: const TextStyle(
                                          backgroundColor: Color.fromARGB(
                                              255, 239, 242, 241),
                                        ),
                                        decoration: const InputDecoration(
                                            focusColor: Colors.black,
                                            suffixIconColor: Colors.black,
                                            hintText: 'La tua posizione',
                                            suffixIcon: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .only(end: 12.0),
                                              child: Image(
                                                  image: AssetImage(
                                                      'assets/immagini_pharma/arrow_down.png')),
                                            ),
                                            disabledBorder:
                                                InputBorder.none,
                                            filled: true,
                                            fillColor: Color.fromARGB(
                                                255, 239, 242, 241),
                                            enabledBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        color: Colors
                                                            .transparent)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(
                                                            10)))),
                                      )),
                                ],
                              ),
                            ), */
                          ],
                        ),
                      ],
                    )),
                ElevatedButton(
                  onPressed: () => _trySubmit(context),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(212, 50),
                    backgroundColor: Color.fromARGB(255, 47, 161, 148),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text('Continua'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(image: AssetImage('assets/immagini_pharma/Line.png')),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Oppure',
                      style: TextStyle(
                          color: Color.fromARGB(255, 202, 202, 202),
                          fontSize: 14),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Image(image: AssetImage('assets/immagini_pharma/Line.png')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SocialLogin(
                  margin: context.mqw * 0.06,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SvgPicture.asset('assets/ico/google.svg'),
                //     const SizedBox(
                //       width: 80,
                //     ),
                //     SvgPicture.asset('assets/ico/fb.svg'),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
