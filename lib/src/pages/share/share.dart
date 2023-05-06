import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../components/drawer/app_drawer.dart';
import '../../components/primary_nosized_button.dart';
import '../../providers/selected_page_name_provider.dart';

class Share extends ConsumerWidget {
  const Share({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Invita amici"),
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 36),
                Text(
                  context.loc.share_text,
                  style: context.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Image.asset(
                  AppAssets.qr,
                  width: 250,
                ),
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PrimaryNoSizedButton(
                      label: context.loc.share_btn,
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
