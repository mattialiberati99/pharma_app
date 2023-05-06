import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/drawer/app_drawer.dart';
import 'package:pharma_app/src/components/section_vertical.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/pages/home/widgets/home_banner.dart';
import 'package:pharma_app/src/pages/home/widgets/home_cuisine_filter.dart';
import 'package:pharma_app/src/providers/home_cuisines_provider.dart';

import '../../components/main_app_bar.dart';
import '../../components/search_bar/home_search_bar.dart';
import '../../components/section_horizontal.dart';
import '../../helpers/app_config.dart';
import '../../models/cuisine.dart';
import '../../providers/selected_page_name_provider.dart';
import '../../providers/user_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final searchController = TextEditingController(text: '');
  final _advancedDrawerController = AdvancedDrawerController();

  late String? cuisineSelected;

  @override
  void initState() {
    cuisineSelected = ref.read(currentCuisineProvider);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  bool noty = true;

  @override
  Widget build(BuildContext context) {
    final userProv = ref.watch(userProvider);
    FlutterNativeSplash.remove();

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
      drawer: AppDrawer(),
      controller: _advancedDrawerController,
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(),
        //  extendBody: ,
        //  appBar:
        /*      Container(
                      margin: const EdgeInsets.only(right: 40),
                      child: GestureDetector(
                        onTap: () {},
                        child: noty
                            ? const Image(
                                width: 24,
                                height: 24,
                                image: AssetImage(
                                    'assets/immagini_pharma/icon_noti.png'))
                            : const Image(
                                image: AssetImage(
                                    'assets/immagini_pharma/bell.png')),
                      ),
                    ),*/
        // ],
        // ),
        //actions: []),

        appBar: MainAppBar(
          controller: searchController,
          advancedDrawerController: _advancedDrawerController,
          nome: currentUser.value.name ?? 'Tac User',
        ),
        body: SafeArea(
          child: ListView(
            children: [
              const SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Recenti',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 28, 31, 30),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Vedi tutti',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 28, 31, 30),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    child: const Image(
                      width: 362,
                      height: 100,
                      image: AssetImage('assets/immagini_pharma/Banner.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Consumer(builder: (context, ref, _) {
                return HomeCuisineFilter(
                    cuisineSelected: cuisineSelected,
                    onCuisineSelected: (Cuisine cuisine) {
                      print('CuisineID: ${cuisine.id} - ${cuisine.name}');
                      setState(() {
                        cuisineSelected = cuisine.id;
                      });
                      ref.read(homeSelectedCuisineProvider.notifier).state =
                          cuisineSelected!;
                    });
              }),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.mqw * 0.08,
                ),
                child: const SectionHorizontal(
                  title: "Acquistati di recente",
                  subTitle: "Vedi tutto",
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
    /*
        appBar: MainAppBar(
          controller: searchController,
        ),
      */
  }
}
