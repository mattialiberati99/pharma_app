import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/providers/orders_provider.dart';

class AggiungiNota extends StatelessWidget {
  final String currentNote;
  final TextEditingController _nota = TextEditingController();

  AggiungiNota({
    Key? key,
    required this.currentNote,
  }) {
    _nota.text = currentNote;
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 10, bottom: 0, top: 30),
          child: Text(
            "Aggiungi Nota:",
            style: context.textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
          child: Container(
              height: 185,
              padding:
                  EdgeInsets.only(top: 2, left: 12, right: 12, bottom: 2.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  color: Colors.white),
              child: Stack(
                children: [
                  TextField(
                    keyboardType: TextInputType.multiline,
                    scrollPadding: EdgeInsets.zero,
                    controller: _nota,
                    maxLength: null,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintMaxLines: 3,
                      border: InputBorder.none,
                      hintText: 'Scrivi qui le tue note',
                      hintStyle: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              height: 40,
              width: 100,
              child: Consumer(builder: (context, ref, _) {
                return PrimaryNoSizedButton(
                    label: 'SALVA',
                    onPressed: () {
                      Navigator.of(context).pop(_nota.text);
                      ref.read(noteOrderProvider.notifier).state = _nota.text;
                    },
                    height: 55);
              })),
        ),
      ],
    );
  }
}
