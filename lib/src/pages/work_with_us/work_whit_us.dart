import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_app/src/app_assets.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../components/drawer/app_drawer.dart';
import '../../providers/selected_page_name_provider.dart';
import '../../providers/settings_provider.dart';

class WorkWithUs extends ConsumerWidget {
  const WorkWithUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: "Consegna con Tac"),
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 36),
                SvgPicture.asset(AppAssets.bike_big),
                const SizedBox(height: 20),
                Text(
                  context.loc.work_how,
                  style: context.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(context.loc.work_gain,
                    style: context.textTheme.bodyText1,
                    textAlign: TextAlign.center),
                Text(context.loc.work_support,
                    style: context.textTheme.bodyText1,
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(context.loc.work_need,
                    style: context.textTheme.bodyText1
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(context.loc.work_vehicles,
                    style: context.textTheme.bodyText1,
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(context.loc.work_devices,
                    style: context.textTheme.bodyText1,
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(context.loc.work_permission,
                    style: context.textTheme.bodyText1,
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(context.loc.work_age,
                    style: context.textTheme.bodyText1,
                    textAlign: TextAlign.center),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PrimaryNoSizedButton(
                      label: context.loc.work_apply,
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
