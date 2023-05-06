import 'dart:ui';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart';
import '../models/address.dart';
import '../providers/user_provider.dart';
import 'package:flutter/material.dart';

class UpdateRecapitoDialog extends StatelessWidget {
  final Address address;
  final TextEditingController _street = TextEditingController();
  final TextEditingController _description = TextEditingController();


  UpdateRecapitoDialog({
    Key? key, required this.address,
  }) : super(key: key) {
    _street.text = address.address!;
    _description.text=address.description!;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: contentBox(context),

    );
  }

  contentBox(BuildContext context) {
    return Container(
        height: 350,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(

          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), blurRadius: 5, offset: Offset(0, 2)),
          // ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).update_recapito,
              style: ExtraTextStyles.bigBlackBold,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(S.current.name,style: ExtraTextStyles.normalBlackBold,),
            TextField(
              keyboardType: TextInputType.name,
              controller: _description,
              style: ExtraTextStyles.normalBlack,
              decoration: InputDecoration(
                fillColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
                hintText: S.of(context).description,
                hintStyle: ExtraTextStyles.smallGreyW,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(S.current.address,style: ExtraTextStyles.normalBlackBold,),
            TextField(
              keyboardType: TextInputType.streetAddress,
              controller: _street,
              style: ExtraTextStyles.normalBlack,
              decoration: InputDecoration(
                fillColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
                hintText: S.of(context).address,
                hintStyle: ExtraTextStyles.smallGreyW,
              ),
            ),

            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  // color: Colors.black,
                  // padding: EdgeInsets.symmetric(horizontal: 0),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(4.0),
                  //   //side: BorderSide(color: Colors.red)
                  // ),
                  child: new Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    address.address = _street.text;
                    address.description=_description.text;
                    Navigator.of(context).pop(address);
                  },
                ),
                ElevatedButton(
                  // color: AppColors.mainBlack,
                  // padding: EdgeInsets.symmetric(horizontal: 0),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(4.0),
                  //   //side: BorderSide(color: Colors.red)
                  // ),
                  child: new Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
