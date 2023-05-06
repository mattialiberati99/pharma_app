import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../app_assets.dart';
import '../../components/drawer/app_drawer.dart';
import '../../components/primary_nosized_button.dart';
import '../../providers/selected_page_name_provider.dart';

class Partner extends ConsumerWidget {
  const Partner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Diventa partner"),
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 36),
                SvgPicture.asset(AppAssets.partner_big),
                const SizedBox(height: 20),
                Text(
                  context.loc.partner_text,
                  style: context.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PrimaryNoSizedButton(
                      label: context.loc.partner_btn,
                      onPressed: () {},
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
