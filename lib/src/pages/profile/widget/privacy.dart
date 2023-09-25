import 'package:flutter/material.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:http/http.dart' as http;

import '../../../helpers/helper.dart';
import '../../../providers/settings_provider.dart';
import '../../../repository/settings_repository.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  String privacyText = "";
  String termsText = "";

  void initState() {
    loadText();
    super.initState();
  }

  void loadText() async {
    var response = await http.get(Uri.parse(setting.value.privacyUrl!));
    privacyText = response.body;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//TODO stringhe
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Termini e condizioni",
          style: context.textTheme.bodyText2?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Helper.applyHtml(privacyText),
          ),
        ),
      ],
    );
  }
}
