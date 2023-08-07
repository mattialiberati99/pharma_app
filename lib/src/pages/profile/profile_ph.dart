import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pharma_app/src/pages/profile/widget/profile_app_bar.dart';

import '../../components/bottomNavigation.dart';
import '../../helpers/validators.dart';
import '../../providers/user_provider.dart';

class ProfilePh extends StatefulWidget {
  const ProfilePh({super.key});

  @override
  State<ProfilePh> createState() => _ProfilePhState();
}

class _ProfilePhState extends State<ProfilePh> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProfileAppBar(
        title: "Profilo",
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
              width: 327,
              height: 56,
              child: TextFormField(
                initialValue: currentUser.value.name,
                decoration: const InputDecoration(
                  prefixIcon: Image(
                    color: Color.fromARGB(115, 9, 28, 63),
                    image: AssetImage('assets/immagini_pharma/icon_profil.png'),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 205, 207, 206))),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                ),
                onSaved: (input) => currentUser.value.name = input,
                validator: (input) {
                  Validators.validateEmail(input, context);
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
              width: 327,
              height: 56,
              child: TextFormField(
                initialValue: currentUser.value.email,
                decoration: const InputDecoration(
                  prefixIcon: Image(
                    color: Color.fromARGB(115, 9, 28, 63),
                    image: AssetImage('assets/immagini_pharma/mail.png'),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 205, 207, 206))),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                ),
                onSaved: (input) => currentUser.value.email = input,
                validator: (input) {
                  Validators.validateEmail(input, context);
                },
                //prefixIcon: Icon(Icons.email,color: Colors.white,),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
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
              width: 327,
              height: 56,
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
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
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
                          width: 2, color: Color.fromARGB(255, 205, 207, 206))),
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 205, 207, 206)),
                ),
                onSaved: (input) => currentUser.value.password = input,
                validator: (input) {
                  Validators.validateEmail(input, context);
                },
                //prefixIcon: Icon(Icons.email,color: Colors.white,),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(
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
              width: 327,
              child: TextFormField(
                initialValue: currentUser.value.name,
                decoration: const InputDecoration(
                  prefixIcon: Image(
                    image: AssetImage('assets/immagini_pharma/tessSan.png'),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 205, 207, 206))),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                ),
                onSaved: (input) => currentUser.value.email = input,
                validator: (input) {
                  Validators.validateEmail(input, context);
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
              width: 327,
              height: 56,
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
                          width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromARGB(255, 205, 207, 206)),
                  ),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 205, 207, 206))),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 205, 207, 206)),
                ),
                onSaved: (input) => currentUser.value.email = input,
                validator: (input) {
                  Validators.validateEmail(input, context);
                },
                //prefixIcon: Icon(Icons.email,color: Colors.white,),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ]),
        ),
      ),
    );
  }
}
