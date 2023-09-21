import 'package:flutter/material.dart';
import 'package:pharma_app/src/pages/profile/widget/orders_history.dart';
import 'package:pharma_app/src/pages/profile/widget/orders_recent.dart';

import '../app_assets.dart';
import '../pages/profile/widget/addresses.dart';
import '../pages/profile/widget/payment_methods_profile.dart';
import '../pages/profile/widget/personal_info.dart';
import '../pages/profile/widget/privacy.dart';

/// Represents the app general categories
enum CategoryGeneral {
  none(label: '', iconPath: '', id: ''),
  spesa(label: 'Spesa', iconPath: 'assets/ico/spesa.svg', id: 'risto'),
  dolci(label: 'Dolci', iconPath: 'assets/ico/dolci.svg', id: 'dolci'),
  shop(label: 'Shopping', iconPath: 'assets/ico/shopping.svg', id: 'shop'),
  tuttopiu(
      label: 'Di tutto un pò',
      iconPath: 'assets/ico/tuttopiu.svg',
      id: 'tuttoGen'),
  sconti(label: 'Sconti', iconPath: 'assets/ico/sconti.svg', id: 'sconti'),
  farma(label: 'Farmacie', iconPath: 'assets/ico/farmacie.svg', id: 'farma'),
  risto(
      label: 'Ristoranti', iconPath: 'assets/ico/ristoranti.svg', id: 'risto');

  const CategoryGeneral(
      {required this.label, required this.iconPath, required this.id});

  final String label;
  final String iconPath;

  ///id potròà essere il filtro per il provider
  final String id;
}

/// Represents the restaurant category
enum CategoryRestaurant {
  tutto(label: 'Tutto', iconPath: 'assets/ico/tutto.svg', id: 'tuttoRisto'),
  pizza(label: 'Pizza', iconPath: 'assets/ico/pizza.svg', id: 'pizza'),
  pesce(label: 'Pesce', iconPath: 'assets/ico/pesce.svg', id: 'pesce'),
  fastfood(
      label: 'Fast Farmaco', iconPath: 'assets/ico/fastfood.svg', id: 'fast');

  const CategoryRestaurant(
      {required this.label, required this.iconPath, required this.id});

  final String label;
  final String iconPath;
  final String id;
}

Map<String, dynamic> categories = {
  //'general': CategoryGeneral,
  'risto': CategoryRestaurant,
};

// TODO valutare ordina di nuovo
enum ProfileSections {
  info(label: "Info", iconPath: AppAssets.profile, content: PersonalInfo()),
  indirizzi(
      label: "Indirizzi di\nspedizione",
      iconPath: AppAssets.addresses,
      content: Addresses()),
  ordini(
      label: "Ordini\nrecenti",
      iconPath: AppAssets.orders,
      content: OrdersRecent()),
  // reorder(label: "Ordina di\nnuovo", iconPath: AppAssets.reorder,content: OrdersHistory()),
  paymethods(
      label: "Metodi di pagamento",
      iconPath: AppAssets.payments,
      content: PaymentMethodsProfile()),
  privacy(
      label: "Condizioni e privacy",
      iconPath: AppAssets.privacy,
      content: Privacy());

  const ProfileSections(
      {required this.label, required this.iconPath, required this.content});

  final String label;
  final String iconPath;
  final Widget content;
}

class App {
  late BuildContext _context;
  late double _height;
  late double _width;
  late double _heightPadding;
  late double _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData _queryData = MediaQuery.of(this._context);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height -
        ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height * v;
  }

  double appWidth(double v) {
    return _width * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding * v;
  }

  double appHorizontalPadding(double v) {
//    int.parse(settingRepo.setting.mainColor.replaceAll("#", "0xFF"));
    return _widthPadding * v;
  }

  static ButtonStyle flatButtonStyle({backColor = AppColors.mainBlack}) =>
      TextButton.styleFrom(
        minimumSize: Size(88, 44),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        backgroundColor: backColor,
      );
}

class AppColors {
  static const Color primary = Color.fromARGB(255, 47, 171, 148);
  static const Color gray1 = Color(0xFF333333);
  static const Color gray2 = Color(0xFF4F4F4F);
  static const Color gray3 = Color(0xFF828282);
  static const Color gray4 = Color(0xFFBDBDBD);
  static const Color gray5 = Color(0XFFE0E0E0);
  static const Color gray6 = Color(0XFFF2F2F2);
  static const Color gray7 = Color(0XFFF7F8F9);
  static const Color gray8 = Color(0XFFDADADA);

  static const Color lightGray1 = Color(0xFFF3F3F3);
  static const Color lightBlack1 = Color(0xFF191D31);
  static const Color solidBlack = Color(0xFF323232);
  static const Color solidGrayLight = Color(0xFFC7C7CC);

//grigio per campi login 0XFFEEEEEE
//sfondo drawer 0XFFEDECE7
// grigio chiaro per bordi container 0XFFE8E8E8
//grigio bordo ricerca 0XFFD9D0E3
// grigio icone filtri Color(0xFFF1F1F1)

  static const Color mainBlack = Color(0xff242424);
  static const Color secondColor = Color(0xFF28B4A6);
  static const Color secondDarkColor = Color(0xff909090);
  static const Color accentColor = Color(0xfff5f5f5);
  static const Color backgroundColor = Color(0xffffffff);
  static const Color error = Color(0xFFFF6160);
}

class ExtraTextStyles {
  static const fontFamily = 'Montserrat-Regular';
  static const fontFamilyRegular = 'Montserrat-Regular';
  static const fontFamilySemiBold = 'Montserrat-SemiBold';
  static const fontFamilyBold = 'Montserrat-Bold';

  static const hugeFontSize = 32.0;
  static const bigFontSize = 24.0;
  static const largeFontSize = 18.0;
  static const normalFontSize = 16.0;
  static const mediumFontSize = 14.0;
  static const smallFontSize = 12.0;
  static const tinyFontSize = 10.0;

  static const tinyBlack = TextStyle(
      fontSize: 10.0,
      color: Colors.black,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static const smallBlack = TextStyle(
      fontSize: 12.0,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static const smallBlackBold = TextStyle(
      fontSize: 12.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static const mediumPrimarySemiBold = TextStyle(
      fontSize: mediumFontSize,
      color: AppColors.primary,
      fontFamily: fontFamilySemiBold);
  static const mediumSmallBlackBold = TextStyle(
      fontSize: 14.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static const normalBlack = TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static const normalBlackBold = TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static const bigBlack = TextStyle(
      fontSize: 24.0,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static const bigBlackBold = TextStyle(
      fontSize: 24.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static const hugeBlack = TextStyle(
      fontSize: 32.0,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static const hugeBlackBold = TextStyle(
      fontSize: 32.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static const tinyWhite = TextStyle(
      fontSize: 10.0,
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static const smallWhite = TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static const normalWhite = TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static const bigWhite = TextStyle(
      fontSize: 24.0,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily,
      decoration: TextDecoration.none);
  static const hugeWhite = TextStyle(
      fontSize: 32.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final tinyGrey = TextStyle(
      fontSize: 10.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static final smallGrey = TextStyle(
      fontSize: 12.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalGrey = TextStyle(
      fontSize: 16.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalGreyBold = TextStyle(
      fontSize: 16.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static const mediumGrey = TextStyle(
      fontSize: mediumFontSize,
      color: AppColors.gray3,
      fontFamily: fontFamilyRegular);
  static final bigGrey = TextStyle(
      fontSize: 24.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugeGrey = TextStyle(
      fontSize: 32.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugeGreyBold = TextStyle(
      fontSize: 32.0,
      color: Colors.grey[600],
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static smallColor(Color color) => TextStyle(
      fontSize: 12.0,
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);

  static smallColorBold(Color color) =>
      TextStyle(fontSize: 12.0, color: color, fontFamily: fontFamilyBold);

  static mediumColor(Color color) => TextStyle(
      fontSize: 14.0,
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);

  static mediumColorBold(Color color) => TextStyle(
      fontSize: 14.0,
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static normalColorBold(Color color) => TextStyle(
      fontSize: normalFontSize,
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final tinyGreyW = TextStyle(
      fontSize: 10.0,
      color: Colors.grey,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static final smallGreyW = TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily);
  static final mediumSmallGreyW = TextStyle(
      fontSize: 14.0,
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalGreyW = TextStyle(
      fontSize: 16.0,
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalGreyWBold = TextStyle(
      fontSize: 16.0,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);
  static final bigGreyW = TextStyle(
      fontSize: 24.0,
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugeGreyW = TextStyle(
      fontSize: 32.0,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final tinyPrimary = TextStyle(
      fontSize: 10.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static final smallPrimary = TextStyle(
      fontSize: 12.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalPrimary = TextStyle(
      fontSize: 16.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final bigPrimary = TextStyle(
      fontSize: 24.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugePrimary = TextStyle(
      fontSize: 32.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final tinyAccent = TextStyle(
      fontSize: 10.0,
      color: AppColors.secondColor,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static final smallAccent = TextStyle(
      fontSize: 12.0,
      color: AppColors.secondColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalAccent = TextStyle(
      fontSize: 16.0,
      color: AppColors.secondColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final bigAccent = TextStyle(
      fontSize: 24.0,
      color: AppColors.secondColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugeAccent = TextStyle(
      fontSize: 32.0,
      color: AppColors.secondColor,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final tinySecondary = TextStyle(
      fontSize: 10.0,
      color: AppColors.accentColor,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static final smallSecondary = TextStyle(
      fontSize: 12.0,
      color: AppColors.accentColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalSecondary = TextStyle(
      fontSize: 16.0,
      color: AppColors.accentColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final bigSecondary = TextStyle(
      fontSize: 24.0,
      color: AppColors.accentColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugeSecondary = TextStyle(
      fontSize: 32.0,
      color: AppColors.accentColor,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final tinyAlternative = TextStyle(
      fontSize: 10.0,
      color: AppColors.secondDarkColor,
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily);
  static final smallAlternative = TextStyle(
      fontSize: 12.0,
      color: AppColors.secondDarkColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final normalAlternative = TextStyle(
      fontSize: 16.0,
      color: AppColors.secondDarkColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final bigAlternative = TextStyle(
      fontSize: 24.0,
      color: AppColors.secondDarkColor,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);
  static final hugeAlternative = TextStyle(
      fontSize: 32.0,
      color: AppColors.secondDarkColor,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static normalColor(Color color) => TextStyle(
      fontSize: 16.0,
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily);

  static normalColorUnderlined(Color color) => TextStyle(
      fontSize: 16.0,
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily,
      decoration: TextDecoration.underline);
}
