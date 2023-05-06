import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/l10n.dart';
import '../../../helpers/app_config.dart';

class EmptyCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.of(context).pop(),
                  color: const Color(0xFF333333),
                ),
                const Text(
                  'Carrello',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('Cart');
                  },
                  child: const Image(
                      image:
                          AssetImage('assets/immagini_pharma/Icon_shop.png')),
                )
              ],
            ),
           const SizedBox(
              height: 100,
            ),
            SvgPicture.asset(
              'assets/ico/cart_empty.svg',
              width: 120,
              height: 120,
              color: AppColors.mainBlack,
            ),
            Text(
              S.of(context).empty_cart,
              style: ExtraTextStyles.bigBlackBold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
