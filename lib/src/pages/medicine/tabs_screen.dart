import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pharma_app/src/pages/medicine/armadietto_screen.dart';
import 'package:pharma_app/src/pages/medicine/terapie_screen.dart';

import '../../components/drawer/app_drawer.dart';
import '../../components/meds_app_bar.dart';
import '../../models/farmaco.dart';
import '../../components/bottomNavigation.dart';

class TabsScreen extends StatefulWidget {
  final List<Farmaco> leMieMedicine;
  final List<Farmaco> leMieTerapie;

  TabsScreen(this.leMieMedicine, this.leMieTerapie);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // ignore: unnecessary_new
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 245),
      bottomNavigationBar: const BottomNavigation(),
      resizeToAvoidBottomInset: false,
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      appBar: MedsAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF46617A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF556b81),
              ),
              unselectedLabelColor: Color(0xFFC7D0D7),
              labelColor: Colors.white,
              tabs: const [
                Tab(text: 'Terapie'),
                Tab(text: 'Armadietto'),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TerapieScreen(),
                ArmadiettoScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
