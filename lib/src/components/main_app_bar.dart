import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pharma_app/src/components/button_menu.dart';
import 'package:pharma_app/src/components/search_bar/home_search_bar.dart';
import 'package:pharma_app/src/providers/notification_provider.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

import '../app_assets.dart';
import '../helpers/app_config.dart';
import 'custom_toggle.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final AdvancedDrawerController advancedDrawerController;
  MainAppBar(
      {Key? key,
      required this.controller,
      required this.advancedDrawerController,
      required this.nome,
      required this.indirizzo})
      : super(key: key);
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    advancedDrawerController.showDrawer();
  }

  @override
  Size get preferredSize => const Size.fromHeight(237);

  final String nome;
  final String indirizzo;

//TODO migliorare
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationProv = ref.watch(notificationProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Container(
          height: 237,
          margin: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width - 130),
                    child: IconButton(
                      onPressed: _handleMenuButtonPressed,
                      icon: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: advancedDrawerController,
                        builder: (_, value, __) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 250),
                            child: value.visible
                                ? Image(
                                    image: const AssetImage(
                                        'assets/immagini_pharma/close.png'),
                                    key: ValueKey<bool>(value.visible),
                                  )
                                : Image(
                                    width: 19.6,
                                    height: 14,
                                    image: const AssetImage(
                                        'assets/immagini_pharma/menu.png'),
                                    key: ValueKey<bool>(value.visible),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 40),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('Notifiche');
                      },
                      child: notificationProv.notifications.isNotEmpty
                          ? const Image(
                              width: 24,
                              height: 24,
                              image: AssetImage(
                                  'assets/immagini_pharma/icon_noti.png'))
                          : const Image(
                              image: AssetImage(
                                  'assets/immagini_pharma/bell.png')),
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
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Text(
                        'Bentornato, ',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
                  Text(
                    '$nome!',
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Image(
                        image: AssetImage(
                            'assets/immagini_pharma/icon_location.png')),
                  ),
                  Text(
                    indirizzo,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  /* const Text(
                    ' Italia',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),*/
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: TextField(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed('Search'),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'Cerca prodotto',
                            // Barcode
                            /*  suffixIcon: SizedBox(
                              child: Image(
                                image: AssetImage(
                                    'assets/immagini_pharma/barcode.png'),
                              ),
                            ), */
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 205, 207, 206)),
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor:
                                Color.fromARGB(255, 167, 166, 165)),
                        autofocus: false,
                      ),
                    ),
                  ),
                  //    CustomFormField(
                  //      controller: controller,
                  //      onSaved: (input) => {},
                  //       validator: (_) {},
                  //      hintText: "Cerca",
                  //      borderColor: AppColors.gray6,
                  //     suffixIcon: SvgPicture.asset(AppAssets.search), validate: true,
                  // ),

                  Container(
                    margin: const EdgeInsets.only(left: 3),
                    width: 20,
                    height: 20,
                    // Pulsante filtri
                    /*   child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 161, 148),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: const Image(
                        width: 22,
                        height: 22,
                        image: AssetImage('assets/immagini_pharma/Vector.png'),
                      ),
                    ), */
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
