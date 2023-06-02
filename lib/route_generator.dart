import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharma_app/src/models/farmaco.dart';
import 'package:pharma_app/src/models/order.dart';
import 'package:pharma_app/src/models/route_argument.dart';
import 'package:pharma_app/src/models/shop.dart';
import 'package:pharma_app/src/pages/cart/checkout.dart';
import 'package:pharma_app/src/pages/cart/mappa_farmacie.dart';
import 'package:pharma_app/src/pages/chat/chat_page.dart';
import 'package:pharma_app/src/pages/contact_us/contact_us.dart';
import 'package:pharma_app/src/pages/favourites/favorite.dart';
import 'package:pharma_app/src/pages/login/otp_screen.dart';
import 'package:pharma_app/src/pages/login/preSignUp.dart';
import 'package:pharma_app/src/pages/login/success_verification_page.dart';
import 'package:pharma_app/src/pages/login/verify_otp.dart';
import 'package:pharma_app/src/pages/medicine/reminder_screen.dart';
import 'package:pharma_app/src/pages/medicine/tabs_screen.dart';
import 'package:pharma_app/src/pages/medicine/terapie_screen.dart';
import 'package:pharma_app/src/pages/notifications/notifications.dart';
import 'package:pharma_app/src/pages/orders/order.dart';
import 'package:pharma_app/src/pages/partner/partner.dart';
import 'package:pharma_app/src/pages/payment_cards/gestisci_carte.dart';
import 'package:pharma_app/src/pages/payment_cards/widgets/edit_credit_card_widget.dart';
import 'package:pharma_app/src/pages/payment_methods/payment_methods.dart';
import 'package:pharma_app/src/pages/position/position.dart';
import 'package:pharma_app/src/pages/delivery_addresses/search_address_page.dart';
import 'package:pharma_app/src/pages/preRegistration/preReg.dart';
import 'package:pharma_app/src/pages/product_detail/edit_recipe.dart';
import 'package:pharma_app/src/pages/profile/profile.dart';
import 'package:pharma_app/src/pages/recent_search/search_product.dart';
import 'package:pharma_app/src/pages/setup/splash_screen.dart';
import 'package:pharma_app/src/pages/shop_detail/shop_detail.dart';
import 'package:pharma_app/src/pages/shop_detail/widget/product_detail_sheet.dart';
import 'package:pharma_app/src/pages/shops_by_address/shops_address.dart';
import 'package:pharma_app/src/pages/tracking/tracking.dart';
import 'package:pharma_app/src/pages/work_with_us/work_whit_us.dart';
import 'package:pharma_app/src/repository/paymentCards_repository.dart';
import 'src/components/search_bar/search_bar_terapie.dart';
import 'src/pages/error.dart';
import 'src/pages/filters/filters.dart';
import 'src/pages/home/home.dart';
import 'src/pages/login/login.dart';
import 'src/pages/login/signup.dart';
import 'src/pages/preHome/pre_home.dart';
import 'src/pages/profile/profile_ph.dart';
import 'src/pages/reviews/reviews.dart';
import 'src/pages/cart/cart_page.dart';
import 'src/pages/share/share.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    if (kDebugMode) {
      print("ROUTE = ${settings.name}");
    }

    List<Farmaco> _leMieMedicine = [];
    List<Farmaco> _leMieTerapie = [];

    switch (settings.name) {
      case 'Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case 'PreRegistration':
        return MaterialPageRoute(builder: (_) => const PreReg());
      case 'PreSignUp':
        return MaterialPageRoute(builder: (_) => const PreSignUp());
      case 'Login':
        return MaterialPageRoute(builder: (_) => const Login());
      case 'SignUp':
        return MaterialPageRoute(builder: (_) => const Signup());
      //case 'MainPage':
      // return MaterialPageRoute(
      //     settings: const RouteSettings(name: "/MainPage"),
      //     builder: (_) => const MainPage(content: PreHome()));
      /* case 'OtpScreen':
        return MaterialPageRoute(builder: (_) => const OtpScreen()); */
      case 'Check':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case 'VerifyOtp':
        return MaterialPageRoute(builder: (_) => const VerifyOtp());
      case 'SuccessVerificationPage':
        return MaterialPageRoute(
            builder: (_) => const SuccessVerificationPage());
      //case 'PreHome':
      // return MaterialPageRoute(builder: (_) => const PreHome());
      case 'Search':
        return MaterialPageRoute(builder: (_) => const SearchProduct());
      case 'Filtri':
        return MaterialPageRoute(builder: (_) => const Filters());
      case 'Reviews':
        return MaterialPageRoute(builder: (_) => const Reviews());
      case 'Reminder':
        return MaterialPageRoute(
            builder: (_) => ReminderScreen(product: args as Farmaco));
      case 'Profilo':
        return MaterialPageRoute(builder: (_) => const ProfilePh());
      case 'Ordini':
        return MaterialPageRoute(builder: (_) => OrderP());
      case 'GestisciCarte':
        return MaterialPageRoute(
            builder: (_) => CarteWidget(isOrder: (args as bool?) ?? false));
      case 'NewCard':
        return MaterialPageRoute(
            builder: (_) => Material(
                  child: EditCreditCardWidget(onChanged: (card) async {
                    if (card == null) {
                      await addCreditCard(card!);
                    } else {
                      if (card != null) {
                        await updateCreditCard(card);
                      }
                    }
                  }),
                ));
      case 'Home':
        return MaterialPageRoute(builder: (_) => const Home());
      case 'Le Mie Medicine':
        return MaterialPageRoute(
            builder: (_) => TabsScreen(_leMieMedicine, _leMieTerapie));
      case 'Notifiche':
        return MaterialPageRoute(builder: (_) => const NotificationsWidget());
      case 'Preferiti':
        return MaterialPageRoute(builder: (_) => const Favorite());
      case 'Chat':
        return MaterialPageRoute(
            builder: (_) => ChatPage(routeArgument: args as RouteArgument));
      case 'Contattaci':
        return MaterialPageRoute(builder: (_) => const ContactUs());
      case 'Diventa Partner':
        return MaterialPageRoute(builder: (_) => const Partner());
      case 'Lavora con Tac':
        return MaterialPageRoute(builder: (_) => const WorkWithUs());
      case 'Condividi Tac':
        return MaterialPageRoute(builder: (_) => const Share());
      case 'Store':
        return MaterialPageRoute(builder: (_) {
          final shop = settings.arguments as Shop;
          return ShopDetail(shop: shop);
        });
      case 'ShopsAddress':
        return MaterialPageRoute(builder: (_) => const ShopsByAddress());
      case 'Product':
        return MaterialPageRoute(builder: (_) {
          final product = settings.arguments as Farmaco;
          return ProductDetailSheet(product: product);
        });
      case 'Cart':
        return MaterialPageRoute(builder: (_) => const CartPage());
      case 'PaymentMethods':
        return MaterialPageRoute(builder: (_) => const PaymentMethods());
      case 'Position':
        return MaterialPageRoute(builder: (_) => const PositionPage());
      case 'SearchAddress':
        return MaterialPageRoute(
            builder: (_) =>
                SearchAddressPage(isOrder: (args as bool?) ?? false));
      case 'Tracking':
        return MaterialPageRoute(builder: (_) => TrackingWidget());
      // case 'Recipe':
      //   return MaterialPageRoute(builder: (_) {
      //     final args = settings.arguments as Map<String, dynamic>;
      //     return EditRecipePage(
      //       product: args['product'],
      //       quantity: args['quantity'],
      //     );
      //   });
      default:
        return MaterialPageRoute(
          builder: (_) => SomethingWrong(
            text: "Pagina non trovata",
            errorIcon: Icons.directions,
            details: settings.name,
            action: Container(),
          ),
        );
    }
  }
}
