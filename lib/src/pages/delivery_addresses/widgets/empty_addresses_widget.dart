import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../helpers/app_config.dart';

class EmptyAddressesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 120,
              color: AppColors.mainBlack,
            ),
            Text(S.of(context).add_new_delivery_address,
                style: ExtraTextStyles.bigBlackBold, textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
