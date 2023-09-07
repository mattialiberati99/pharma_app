import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import '../../../generated/l10n.dart';
import '../../components/AppButton.dart';
import '../../dialogs/ConfirmDialog.dart';
import '../../helpers/custom_trace.dart';
import '../../models/setting.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/settings_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashScreen> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  String _latestLink = 'Unknown';
  int progress = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initDynamicLinks();
      currentUser.addListener(() {
        setState(() {
          print("USER");
          progress += 100;
        });
        if (progress >= 100) {
          loadData();
        }
      });
      setting.addListener(() {
        if (setting.value.appName != null) {
          setState(() {
            print("SETTING");
            progress += 50;
          });
        }
        if (progress >= 100) {
          loadData();
        }
      });
    });
  }

  void locationPermission() async {
    var location = Location();
    var _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    ref.read(userProvider).loadUserFromSavedToken();
    initSettings();
    super.didChangeDependencies();
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      print(deepLink);
      if (deepLink != null) {
        _latestLink = deepLink.path;
        prefs.setString('link', _latestLink);
      }
    }, onError: (e) async {
      print('onLinkError');
      print(e.message);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      _latestLink = deepLink.path;
      prefs.setString('link', _latestLink);
    }
  }

  void loadData() async {
    try {
      String loc = Localizations.localeOf(context).languageCode;
      print(loc);
      Locale locale =
          Locale(await ref.watch(languageProvider).getDefaultLanguage(loc));
      S.delegate.load(locale);
    } catch (e) {
      print(e);
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    if (setting.value.maintenance) {
      Navigator.of(context).pushReplacementNamed('Maintenance');
      return;
    }

    locationPermission();

    if (buildNumber >= setting.value.minVersion!) {
      print(currentUser.value.apiToken);
      if (currentUser.value.apiToken != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (currentUser.value.verified != null) {
            Navigator.of(context).pushReplacementNamed('Home');
          } else {
            Navigator.of(context).pushReplacementNamed('VerifyOtp');
          }
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('PreRegistration');
        });
      }
    } else {
      Navigator.of(context).pushReplacementNamed('Update');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: ExactAssetImage('assets/immagini_pharma/logo.png'),
            fit: BoxFit.cover,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              /*SizedBox(height: 50),
              Image.asset(
                'assets/img/italian_text.png',
                width: 200,
                fit: BoxFit.cover,
              ),*/
              SizedBox(height: 450),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
