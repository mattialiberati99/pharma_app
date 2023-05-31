import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/custom_toggle.dart';
import 'package:pharma_app/src/components/drawer/widgets/drawer_item.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat.dart';
import '../models/route_argument.dart';
import '../providers/chat_provider.dart';
import '../providers/user_provider.dart';

class BottomNavigation extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const BottomNavigation({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(89);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends ConsumerState<BottomNavigation> {
  int countShowBottomSheet = 1;
  bool toggle = false;

  bool selectedH = true;

  bool selectedL = false;

  bool selectedP = false;

  bool selectedC = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool selectedH = true;

    bool selectedL = false;

    bool selectedP = false;

    bool selectedC = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 205, 207, 206),
            blurRadius: 15.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 5  horizontally
              5.0, // Move to bottom 5 Vertically
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22), topRight: Radius.circular(22)),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22)),
          ),
          height: 89,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22)),
            child: Scaffold(
                body: Container(
              height: 89,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (selectedH || selectedC || selectedP || selectedL) {
                        setState(() {
                          selectedH = true;
                          selectedL = false;
                          selectedC = false;
                          selectedP = false;
                        });
                        Navigator.of(context).pushReplacementNamed('Home');
                      }
                    },
                    child: Image(
                        color: selectedH ? AppColors.primary : AppColors.gray4,
                        image: const AssetImage(
                            'assets/immagini_pharma/icon_home.png')),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectedH || selectedC || selectedP || selectedL) {
                        setState(() {
                          selectedL = true;
                          selectedH = false;
                          selectedC = false;
                          selectedP = false;
                        });
                        Navigator.of(context).pushReplacementNamed('Tracking');
                      }
                    },
                    child: Image(
                        color: selectedL ? AppColors.primary : AppColors.gray4,
                        image: const AssetImage(
                            'assets/immagini_pharma/icon_receipt.png')),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      countShowBottomSheet++;
                      if (countShowBottomSheet % 2 == 0) {
                        showBottomSheet(
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Image.asset(
                                          'assets/immagini_pharma/Rectangle.png'),
                                      const SizedBox(height: 30),
                                      DrawerItem(
                                        pageName: 'Terapie',
                                        iconPath:
                                            'assets/ico/Jar Of Pills 2.svg',
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  'Le Mie Medicine');
                                        },
                                      ),
                                      DrawerItem(
                                        pageName: 'Armadietto',
                                        iconPath: 'assets/ico/Medical Kit.svg',
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  'Le Mie Medicine');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pop(context);
                      }

                      setState(() {
                        toggle = !toggle;
                      });
                    },
                    child: toggle
                        ? const Icon(
                            Icons.close,
                            weight: 11,
                          )
                        : Icon(Icons.add, weight: 11),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (selectedH || selectedC || selectedP || selectedL) {
                        setState(() {
                          selectedC = true;
                          selectedL = false;
                          selectedH = false;
                          selectedP = false;
                        });
                        final chatProv = ref.watch(chatProvider);
                        Chat? chat =
                            await chatProv.getChat(currentUser.value.id);
                        Navigator.of(context).pushReplacementNamed('Chat',
                            arguments: RouteArgument(id: chat?.id));
                      }
                    },
                    child: Image(
                        color: selectedC ? AppColors.primary : AppColors.gray4,
                        image: const AssetImage(
                            'assets/immagini_pharma/icon_chat.png')),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedH || selectedC || selectedP || selectedL) {
                          selectedP = true;
                          selectedL = false;
                          selectedC = false;
                          selectedH = false;
                        }
                      });
                      Navigator.of(context).pushReplacementNamed('Profilo');
                    },
                    child: Image(
                        color: selectedP ? AppColors.primary : AppColors.gray4,
                        image: const AssetImage(
                            'assets/immagini_pharma/icon_profil.png')),
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
