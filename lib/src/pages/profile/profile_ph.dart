import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/pages/profile/widget/profile_app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../components/bottomNavigation.dart';
import '../../components/drawer/app_drawer.dart';
import '../../helpers/app_config.dart';
import '../../helpers/validators.dart';
import '../../providers/user_provider.dart';
import '../../repository/user_repository.dart';

class ProfilePh extends ConsumerStatefulWidget {
  const ProfilePh({super.key});

  @override
  ConsumerState<ProfilePh> createState() => _ProfilePhState();
}

class _ProfilePhState extends ConsumerState<ProfilePh> {
  bool hide = true;
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    final userProv = ref.watch(userProvider);
    return AdvancedDrawer(
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppColors.primary, blurRadius: 2.0, spreadRadius: 5.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      disabledGestures: false,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      drawer: const AppDrawer(),
      controller: _advancedDrawerController,
      child: Scaffold(
        appBar: ProfileAppBar(
          title: "Profilo",
          advancedDrawerController: _advancedDrawerController,
        ),
        bottomNavigationBar: BottomNavigation(sel: SelectedBottom.profilo),
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 40),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Il tuo nome',
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 9, 28, 63),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 78.w,
                height: 6.h,
                child: TextFormField(
                  initialValue: currentUser.value.name,
                  decoration: const InputDecoration(
                    prefixIcon: Image(
                      color: Color.fromARGB(115, 9, 28, 63),
                      image:
                          AssetImage('assets/immagini_pharma/icon_profil.png'),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 205, 207, 206)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 205, 207, 206))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  onSaved: (input) => currentUser.value.name = input,
                  validator: (input) {
                    Validators.validateEmail(input);
                  },
                  //prefixIcon: Icon(Icons.email,color: Colors.white,),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'La tua email',
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 9, 28, 63),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 78.w,
                height: 6.h,
                child: TextFormField(
                  initialValue: currentUser.value.email,
                  decoration: const InputDecoration(
                    prefixIcon: Image(
                      color: Color.fromARGB(115, 9, 28, 63),
                      image: AssetImage('assets/immagini_pharma/mail.png'),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 205, 207, 206)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 205, 207, 206))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  onSaved: (input) => currentUser.value.email = input,
                  validator: (input) {
                    Validators.validateEmail(input);
                  },
                  //prefixIcon: Icon(Icons.email,color: Colors.white,),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: SizedBox(
                  width: 50.w,
                  height: 5.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                  'Sei sicuro di voler eliminare il tuo account? '
                                  'Questa azione non può essere annullata.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Annulla'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    deleteUser().then((v) {
                                      if (currentUser.value.apiToken != null) {
                                        UserProvider.logout().then((value) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  'Login',
                                                  (Route<dynamic> route) =>
                                                      false,
                                                  arguments: false);
                                        });
                                      } else {
                                        Navigator.of(context).pushNamed('Login',
                                            arguments: false);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Elimina'),
                                )
                              ],
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    label: const Text('Elimina account'),
                  ),
                ),
              ),
              /*     const Text(
                'Password',
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 9, 28, 63),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 78.w,
                height: 6.h,
                child: TextFormField(
                  initialValue: currentUser.value.password,
                  obscureText: hide ? true : false,
                  decoration: InputDecoration(
                    prefixIcon: const Image(
                      color: Color.fromARGB(115, 9, 28, 63),
                      image: AssetImage('assets/immagini_pharma/pass.png'),
                    ),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 205, 207, 206)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                    ),
                    enabled: true,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          hide = !hide;
                        });
                        print(hide);
                      },
                      child: const Image(
                        color: Color.fromARGB(115, 9, 28, 63),
                        image: AssetImage('assets/immagini_pharma/hide.png'),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 205, 207, 206))),
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  onSaved: (input) => currentUser.value.password = input,
                  validator: (input) {
                    Validators.validateEmail(input);
                  },
                  //prefixIcon: Icon(Icons.email,color: Colors.white,),
                  textInputAction: TextInputAction.next,
                ),
              ), */
              /*  const SizedBox(
                height: 15,
              ),
              const Text(
                'Tessera Sanitaria',
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 9, 28, 63),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 78.w,
                height: 6.h,
                child: TextFormField(
                  initialValue: currentUser.value.name,
                  decoration: const InputDecoration(
                    prefixIcon: Image(
                      image: AssetImage('assets/immagini_pharma/tessSan.png'),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 205, 207, 206)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 205, 207, 206))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  onSaved: (input) => currentUser.value.email = input,
                  validator: (input) {
                    Validators.validateEmail(input);
                  },
                  //prefixIcon: Icon(Icons.email,color: Colors.white,),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Collega Carte',
                style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 9, 28, 63),
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 78.w,
                height: 6.h,
                child: TextFormField(
                  initialValue: currentUser.value.name,
                  decoration: const InputDecoration(
                    suffixIcon: Image(
                      image: AssetImage('assets/immagini_pharma/arrdow.png'),
                    ),
                    prefixIcon: Image(
                      image: AssetImage('assets/immagini_pharma/carta.png'),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 205, 207, 206)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 205, 207, 206))),
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  onSaved: (input) => currentUser.value.email = input,
                  validator: (input) {
                    Validators.validateEmail(input);
                  },
                  //prefixIcon: Icon(Icons.email,color: Colors.white,),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 40,
              ), */
            ]),
          ),
        ),
      ),
    );
  }
}
