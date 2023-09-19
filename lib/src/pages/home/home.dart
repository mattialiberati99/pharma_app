import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/drawer/app_drawer.dart';
import 'package:pharma_app/src/components/section_vertical.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/pages/home/widgets/home_banner.dart';
import 'package:pharma_app/src/pages/home/widgets/home_cuisine_filter.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';
import 'package:pharma_app/src/providers/home_cuisines_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/main_app_bar.dart';
import '../../components/search_bar/home_search_bar.dart';
import '../../components/section_horizontal.dart';
import '../../helpers/app_config.dart';
import '../../models/cuisine.dart';
import '../../providers/selected_page_name_provider.dart';
import '../../providers/user_provider.dart';
import '../categorie+/categorie.dart';

String locationText = "";

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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

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
    final categorie = ref.watch(categoriesProvider);
    final userProv = ref.watch(userProvider);

    FlutterNativeSplash.remove();

    _getLocation();

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
        bottomNavigationBar: BottomNavigation(sel: SelectedBottom.home),
        //extendBody: ,
        //appBar:
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
                            const Image(
                                image: AssetImage(
                                    'assets/immagini_pharma/bell.png')),
                      )
                    ),*/
        // ],
        // ),
        //actions: []),

        appBar: MainAppBar(
          controller: searchController,
          advancedDrawerController: _advancedDrawerController,
          nome: currentUser.value.name ?? 'Pharma User',
          indirizzo: locationText,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 20),
                    child: const Text(
                      'Categorie',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 28, 31, 30),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 20),
                        width: context.mqw * 0.9,
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categorie.categories.values.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Categorie(categorie
                                        .categories.values
                                        .elementAt(index))));
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.gray4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                width: 64,
                                height: 98,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                          color: AppAssets.colori[index],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Image(
                                          image: AssetImage(
                                              AppAssets.immagini[index])),
                                    ),
                                    Container(
                                      child: Text(
                                        categorie.categories.values
                                            .elementAt(index)
                                            .name!,
                                        style: TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /* return HomeCuisineFilter(
                    cuisineSelected: cuisineSelected,
                    onCuisineSelected: (Cuisine cuisine) {
                      print('CuisineID: ${cuisine.id} - ${cuisine.name}');
                      setState(() {
                        cuisineSelected = cuisine.id;
                      });
                      ref.read(homeSelectedCuisineProvider.notifier).state =
                          cuisineSelected!;
                    });*/

              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.mqw * 0.08,
                ),
                child: const SectionHorizontal(
                  title: "Acquistati di recente",
                  subTitle: "",
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

  void _getLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String cityName = placemarks.first.locality ?? "Sconosciuto";
      String regionName = placemarks.first.administrativeArea ?? "Sconosciuto";
      String countryName = placemarks.first.country ?? "Sconosciuto";
      setState(() {
        locationText = "$cityName, $regionName, $countryName";
      });
    } catch (e) {
      setState(() {
        locationText = "Impossibile ottenere posizione";
      });
    }
  }
}
