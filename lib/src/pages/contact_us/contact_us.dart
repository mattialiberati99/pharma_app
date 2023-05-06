import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app_assets.dart';
import '../../components/drawer/app_drawer.dart';
import '../../components/primary_nosized_button.dart';
import '../../providers/settings_provider.dart';

class ContactUs extends ConsumerStatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends ConsumerState<ContactUs> {
  late String _phone;
  bool _hasCallSupport = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _phone = setting.value.phoneSupport;
        _hasCallSupport = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Richiesta Informazioni"),
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 36),
                SvgPicture.asset(AppAssets.phone),
                const SizedBox(height: 20),
                Text(
                  context.loc.contact_text1,
                  style: context.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PrimaryNoSizedButton(
                      label: context.loc.contact_btn1,
                      onPressed: () => _makePhoneCall(_phone),
                      height: 60),
                ),
                const SizedBox(height: 50),
                SvgPicture.asset(AppAssets.chat),
                const SizedBox(height: 20),
                Text(
                  context.loc.contact_text2,
                  style: context.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PrimaryNoSizedButton(
                      label: context.loc.contact_btn2,
                      onPressed: () => launchUrlString(
                          'mailto:${setting.value.mailSupport}'),
                      height: 60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// ElevatedButton(
// onPressed: _hasCallSupport
// ? () => setState(() {
// _launched = _makePhoneCall(_phone);
// })
//     : null,
// child: _hasCallSupport
// ? const Text('Make phone call')
//     : const Text('Calling not supported'),
// ),

