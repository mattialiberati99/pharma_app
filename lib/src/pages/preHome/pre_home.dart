import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/app_theme.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/shop.dart';
import 'package:pharma_app/src/pages/position/position.dart';
import 'package:pharma_app/src/pages/preHome/widgets/best_tac_sheet.dart';
import 'package:pharma_app/src/pages/preHome/widgets/macro_categories_menu.dart';

import '../../components/search_bar/pre_home_search_bar.dart';
import '../../helpers/geolocator_utils.dart';
import '../../providers/home_cuisines_provider.dart';
import '../../providers/selected_page_name_provider.dart';
import '../../repository/settings_repository.dart' as settingRepo;
import 'package:pharma_app/src/providers/position_provider.dart';

import '../../components/button_menu.dart';
import '../../components/drawer/app_drawer.dart';
import '../../helpers/app_config.dart';
import '../../models/address.dart';
import '../../models/cuisine.dart';
import '../../providers/cuisines_provider.dart';
import '../../repository/settings_repository.dart';

class PreHome extends ConsumerStatefulWidget {
  const PreHome({super.key});

  @override
  ConsumerState<PreHome> createState() => _PreHomeState();
}

class _PreHomeState extends ConsumerState<PreHome> {
  String? cuisineSelected;
  late CategoryGeneral selectedCategory;
  late Address address;
  List<Shop>? bests;
  var _isSearchExpanded = false;

  void toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });
  }

  // void initBest() async {
  //   final myLocation = ref.watch(positionProvider).currentAddress;
  //   if (mounted) {
  //     bests = await getPopularRestaurants(myLocation);
  //     setState(() {});
  //   }
  // }

  void loadUserPosition(BuildContext context) async {
    Address address = new Address();
    Position? lastLocation = await GeoLocatorUtils.getLastKnownPosition();
    if (lastLocation != null) {
      settingRepo.setCurrentLocation();
      address.latitude = lastLocation.latitude;
      address.longitude = lastLocation.longitude;
      address.address = null;
    } else {
      lastLocation = await GeoLocatorUtils.getCurrentPosition();
      settingRepo.setCurrentLocation();
      address.latitude = lastLocation.latitude;
      address.longitude = lastLocation.longitude;
      address.address = null;
    }

    settingRepo.changeCurrentLocation(address);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    selectedCategory = CategoryGeneral.none;
    if (kDebugMode) {
      print("init");
    }
    //_con.loadLinks();
    address = settingRepo.deliveryAddress.value;
    if (kDebugMode) {
      print('ADDRESS: ${address.address}');
    }
    loadUserPosition(context);
    Future.delayed(
        Duration(milliseconds: 500), () => FlutterNativeSplash.remove());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ref.read(positionProvider).silentRefresh();
    initSettings();
    super.didChangeDependencies();
    print("CURRENT ADDRESS CHANGED");
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userPositionProvider);
    // ref.read(positionProvider).refreshAddress(context);

    final macroCategories = ref.watch(macroCategoriesProvider);
    var cucine = macroCategories.cuisines;

    final nSize = context.mqw * 0.25;
    final lSize = context.mqw * 0.28;

    DateTime lastExitTime = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(lastExitTime) >=
            const Duration(seconds: 1)) {
          final snack = SnackBar(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 60),
            behavior: SnackBarBehavior.floating,
            clipBehavior: Clip.none,
            backgroundColor: AppColors.primary.withOpacity(0.8),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            content: Text(
              context.loc.snack_text,
              style: context.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            duration: const Duration(seconds: 2),
          );
          lastExitTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false; // disable back press
        } else {
          return true; //  exit the app
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBody: true,
          extendBodyBehindAppBar: false,
          backgroundColor: themeData.colorScheme.secondary,
          drawer: const AppDrawer(),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: context.onSmallScreen ? 110 : 150,
                left: 25,
                right: 25,
                bottom: 500,
                child: Text(
                  context.loc.pre_home_title,
                  style: context.textTheme.overline
                      ?.copyWith(color: const Color(0XFFFFFFFF)),
                ),
              ),
              Positioned(
                top: context.onSmallScreen ? 120 : 170,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MacroCategoriesMenu(
                            cuisineSelected: cuisineSelected,
                            onCuisineSelected: (Cuisine cuisine) {
                              print(
                                  'CusineID: ${cuisine.id} - ${cuisine.name}');
                              setState(() {
                                cuisineSelected = cuisine.id;
                              });
                              setCuisineId(cuisineSelected, ref);
                              navigateToHome(context, ref);
                            }),
                      ]),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: context.mqh * 0.07,
                    right: context.mqw * 0.04,
                    child: AnimatedOpacity(
                      opacity: _isSearchExpanded ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Visibility(
                        visible: _isSearchExpanded,
                        child: IconButton(
                          color: context.colorScheme.primary,
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close),
                          onPressed: toggleSearch,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: context.mqh * 0.07,
                    left: context.mqw * 0.06,
                    child: AnimatedOpacity(
                      opacity: _isSearchExpanded ? 0 : 1,
                      duration: const Duration(milliseconds: 250),
                      child: Visibility(
                        visible: !_isSearchExpanded,
                        child: Builder(builder: (context) {
                          return ButtonMenu(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            backgroundColor: const Color(0XFFFFFFFF),
                          );
                        }),
                      ),
                    ),
                  ), // <-- MENU BURGER
                  AnimatedPositioned(
                      top: context.mqh * 0.07,
                      right: _isSearchExpanded ? context.mqw * 0.16 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                bottomLeft: const Radius.circular(18),
                                topRight:
                                    Radius.circular(_isSearchExpanded ? 18 : 0),
                                bottomRight:
                                    Radius.circular(_isSearchExpanded ? 18 : 0),
                              ),
                            )),
                        height: 48,
                        width: _isSearchExpanded
                            ? context.mqw * 0.75
                            : context.mqw * 0.73,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: SearchBarPreHome(
                                isExpanded: _isSearchExpanded,
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 12),
                                  child: Row(
                                      mainAxisAlignment: _isSearchExpanded
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.center,
                                      children: [
                                        //TODO valutare azione marker e search
                                        GestureDetector(
                                            onTap: !_isSearchExpanded
                                                ? toggleSearch
                                                : null,
                                            child: SvgPicture.asset(
                                                AppAssets.search)),
                                        const VerticalDivider(
                                          width: 20,
                                          thickness: 1,
                                          indent: 10,
                                          endIndent: 10,
                                          color: Colors.grey,
                                        ),
                                        Consumer(builder: (context, ref, _) {
                                          // final drawerLocation =
                                          //     ref.read(drawerLocationProvider.notifier);
                                          return GestureDetector(
                                              onTap: !_isSearchExpanded
                                                  ? () => Navigator.of(context)
                                                      .pushNamed('Position')
                                                  : () => {
                                                        // drawerLocation.resetNavigation(),
                                                        // drawerLocation.setPrevious(
                                                        //     DrawerNavigationItem
                                                        //         .prehome),
                                                        Navigator.of(context)
                                                            .pushNamed('Filtri')
                                                      },
                                              child: SvgPicture.asset(
                                                  _isSearchExpanded
                                                      ? AppAssets.filter
                                                      : AppAssets.marker));
                                        }),
                                      ]),
                                )),
                          ],
                        ),
                      )), // <-- SEARCH BAR
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: BestTacSheet(),
              )
            ],
          ),
          bottomNavigationBar: const BestTacSheet(),
        ),
      ),
    );
  }

  Future<void> navigateToHome(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pushNamed('Home');
    // ref
    //     .read(selectedPageNameProvider.notifier)
    //     .selectPage(context, 'HomeDynamic');
  }

  void setCuisineId(String? cuisineId, WidgetRef ref) async {
    final currentCuisine = ref.read(currentCuisineProvider.notifier);
    currentCuisine.state = cuisineId!;
    // final currentCuisine = ref.read(currentCuisineProvider);
    // getRestaurantsOfCuisine(currentCuisine);
    // print(currentCuisine);
  }
}
