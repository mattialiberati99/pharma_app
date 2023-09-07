import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:talker/talker.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_app/route_generator.dart';
import 'package:pharma_app/src/app_theme.dart';
import 'package:pharma_app/src/components/AppButton.dart';
import 'package:pharma_app/src/dialogs/ConfirmDialog.dart';
import 'package:pharma_app/src/helpers/custom_trace.dart';
import 'package:pharma_app/src/models/route_argument.dart';
import 'package:pharma_app/src/pages/error.dart';
import 'package:pharma_app/src/providers/settings_provider.dart';
import 'generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

final navigatorKey = GlobalKey<NavigatorState>();
final logger = Talker();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  timeago.setLocaleMessages('it', timeago.ItMessages());

  await GlobalConfiguration().loadFromAsset("debug");
  //await GlobalConfiguration().loadFromAsset("configurations");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null && navigatorKey.currentContext != null) {
      final hidePopupRoutes = ['Chat', 'ChatList'];

      if (hidePopupRoutes.contains(currentRoute.value)) {
        print("nananananoooo");
      } else {
        showDialog(
            context: navigatorKey.currentContext!,
            builder: (_) => ConfirmDialog(
                title: message.notification!.title!,
                description: message.notification!.body!,
                action: AppButton(
                  buttonText: message.data['button_text'] ?? "Controlla",
                  onPressed: () {
                    Navigator.of(navigatorKey.currentContext!).pushNamed(
                        message.data['screen'],
                        arguments: RouteArgument(
                            id: message.data['id'],
                            showFull: message.data['full'] ?? false));
                  },
                )));
      }
    }
  });

  print(CustomTrace(StackTrace.current,
      message: "base_url: ${GlobalConfiguration().getValue('base_url')}"));
  print(CustomTrace(StackTrace.current,
      message:
          "api_base_url: ${GlobalConfiguration().getValue('api_base_url')}"));
  ErrorWidget.builder = (FlutterErrorDetails details) => SomethingWrong(
        text: "Errore!",
        errorIcon: Icons.clear,
        details: details,
        action: Container(),
      );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: App()));
/*   final fCMToken = await FirebaseMessaging.instance.getToken();
  print('TOKEN DEVICE PER FIREBASE:');
  print(fCMToken); */
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Pharmalivero',
      theme: themeData,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: 'Splash',
      locale: const Locale.fromSubtags(languageCode: "it"),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
