import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_app/local_notifications.dart';
import 'package:pharma_app/src/components/drawer/app_drawer.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/components/bottomNavigation.dart';
import 'package:pharma_app/src/providers/categories_provider.dart';
import 'package:pharma_app/src/providers/home_cuisines_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../components/main_app_bar.dart';
import '../../components/section_horizontal.dart';
import '../../helpers/app_config.dart';
import '../../providers/notification_provider.dart';
import '../../providers/user_provider.dart';
import '../PermissionDeniedScreen.dart';
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

  listenToNotification() {
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.of(context).pushNamed('Le Mie Routine');
    });
  }

  @override
  void initState() {
    listenToNotification();
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

  @override
  Widget build(BuildContext context) {
    final categorie = ref.watch(categoriesProvider);
    final userProv = ref.watch(userProvider);
    final notificationProv = ref.watch(notificationProvider);

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
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavigation(sel: SelectedBottom.home),
          appBar: MainAppBar(
            controller: searchController,
            advancedDrawerController: _advancedDrawerController,
            nome: currentUser.value.name ?? 'Ospite',
            indirizzo: locationText,
          ),
          body: ListView(
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
                    onTap: () {
                      if (currentUser.value.apiToken == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const PermissionDeniedScreen())));
                      } else {
                        Navigator.of(context).pushNamed("Le Mie Routine");
                      }
                    },
                    child: Image(
                      width: 87.4.w,
                      height: 11.1.h,
                      image:
                          const AssetImage('assets/immagini_pharma/Banner.png'),
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
                        margin: const EdgeInsets.only(left: 30, top: 20),
                        width: context.mqw * 0.9,
                        height: 15.h,
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
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.gray4),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                ),
                                width: 23.w,
                                height: 15.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            // color: AppAssets.colori[index],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: categorie.categories.values
                                                    .elementAt(index)
                                                    .image
                                                    ?.icon !=
                                                null
                                            ? FittedBox(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: categorie
                                                      .categories.values
                                                      .elementAt(index)
                                                      .image!
                                                      .icon!,
                                                ),
                                              )
                                            : const SizedBox(),
                                        /* Image(
                                          image: AssetImage(
                                              AppAssets.immagini[index]),
                                        ), */
                                      ),
                                      const SizedBox(height: 8),
                                      AutoSizeText(
                                        minFontSize: 9,
                                        maxFontSize: 12,
                                        categorie.categories.values
                                            .elementAt(index)
                                            .name!,
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
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
      if (mounted) {
        setState(() {
          locationText = "Impossibile ottenere posizione";
        });
      }
    }
  }
}
