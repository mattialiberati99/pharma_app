import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/app_config.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

class OrderSuccessDialog extends StatelessWidget {
  final String currentOrder;
  final TextEditingController _nota = TextEditingController();

  OrderSuccessDialog({
    Key? key,
    required this.currentOrder,
  }) {
    _nota.text = currentOrder;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0,
        child: contentBox(context),
      ),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppAssets.order_ok),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Text(
                "ORDINE EFFETTUATO",
                style: context.textTheme.subtitle1?.copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 200),
            Center(
              child: Text(
                "Il tuo ordine è andato a  buon fine",
                style: context.textTheme.bodyText1,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "ID ordine ",
                  style: context.textTheme.bodyText1?.copyWith(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: currentOrder,
                      style: context.textTheme.bodyText1?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            PrimaryNoSizedButton(
                label: "TRACCIA ORDINE",
                hMargin: 36,
                onPressed: () => Navigator.of(context).pushNamed('Tracking'),
                height: 55),
            const SizedBox(height: 8),
            Consumer(builder: (context, ref, _) {
              return TextButton(
                  onPressed: () => {
                        Navigator.pop(context),
                        Navigator.pop(context),
                        Navigator.pop(context),
                        //TODO da sistemare
                      },
                  child: Text(
                    "CONTINUA GLI ACQUISTI",
                    style: context.textTheme.bodyText1?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray4),
                  ));
            }),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
}
//
// Column(
// mainAxisSize: MainAxisSize.min,
// children: <Widget>[
// Padding(
// padding:
// const EdgeInsets.only(right: 10, left: 10, bottom: 0, top: 30),
// child: Text(
// "ORDINE EFFETTUATO",
// style: context.textTheme.bodyText1,
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(16.0),
// child: Container(
// height: 40,
// width: 100,
// child: Consumer(builder: (context, ref, _) {
// return PrimaryNoSizedButton(
// label: 'SALVA',
// onPressed: () {
// Navigator.of(context).pop(_nota.text);
// ref.read(noteOrderProvider.notifier).state = _nota.text;
// },
// height: 55);
// })),
// ),
// ],
// );
