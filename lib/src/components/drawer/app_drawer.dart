import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_app/src/components/custom_toggle.dart';
import 'package:pharma_app/src/components/drawer/widgets/drawer_item.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/models/route_argument.dart';
import 'package:pharma_app/src/providers/chat_provider.dart';
import 'package:pharma_app/src/providers/user_provider.dart';

import '../../app_assets.dart';
import '../../helpers/app_config.dart';

import '../../models/chat.dart';
import '../../providers/selected_page_name_provider.dart';

final _drawerItems = <String>[
  'Home',
  'Le Mie Medicine',
  'Ordini',
  'Preferiti',
  'Chat',
  'Notifiche',
  'Privacy & Policy',
  //'Impostazioni',
];

final _drawerIcons = <String, String>{
  'Home': AppAssets.home,
  'Le Mie Medicine': AppAssets.medicine,
  'Ordini': AppAssets.ordini,
  'Preferiti': AppAssets.preferiti,
  'Chat': AppAssets.chat,
  'Notifiche': AppAssets.noti,
  'Privacy & Policy': AppAssets.privacy2,
  //'Impostazioni': AppAssets.impo,
};

// final selectedPageBuilderProvider = Provider<WidgetBuilder>((ref) {
//   final selectedPageKey = ref.watch(selectedPageNameProvider);
//   return _drawerItems[selectedPageKey]!;
//
// });

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageName = ref.watch(selectedPageNameProvider);
    final userProv = ref.watch(userProvider);

    return Drawer(
      //TODO aggiungere ai colori
      backgroundColor: const Color.fromARGB(255, 243, 252, 245),
      elevation: 1,
      width: context.mqw * 0.8,
      child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Drawer Header
                  ClipRRect(
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        maxHeight: context.mqh * 0.21,
                      ),

                      //TODO leggere user con provider
                      child: Padding(
                        padding: EdgeInsets.only(left: context.mqw * 0.08),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: context.mqh * 0.05,
                            ),
                            SizedBox(
                              height: context.mqh * 0.02,
                            ),
                            GestureDetector(
                              onTap: () => {
                                //      advancedDrawerController.toggleDrawer(),
                                Navigator.of(context).pushNamed('Profilo')
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 44,
                                        width: 44,
                                        child: ClipRRect(
                                            child: Image(
                                          image: currentUser.value.imagePath !=
                                                  null
                                              ? AssetImage(
                                                  currentUser.value.imagePath!)
                                              : const AssetImage(
                                                  'assets/immagini_pharma/logo_small.png'),
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        currentUser.value.name ?? 'Pharma User',
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  for (var pageName in _drawerItems)
                    Stack(
                      children: [
                        DrawerItem(
                            selectedPageName: selectedPageName,
                            pageName: pageName,
                            iconPath: _drawerIcons[pageName]!,
                            onPressed: () async {
                              final chatProv = ref.watch(chatProvider);
                              Chat? chat =
                                  await chatProv.getChat(currentUser.value.id);
                              pageName == 'Chat'
                                  ? Navigator.of(context).pushNamed('Chat',
                                      arguments: RouteArgument(id: chat?.id))
                                  : Navigator.of(context).pushNamed(pageName);
                            }),
                        const Positioned(
                            left: 270,
                            bottom: 15,
                            child: Image(
                              width: 23,
                              height: 23,
                              image: AssetImage(
                                  'assets/immagini_pharma/right-arrow.png'),
                            )),
                      ],
                    ),
                  const Spacer(),
                  DrawerItem(
                      pageName: 'Logout',
                      iconPath: AppAssets.logout,
                      onPressed: () => UserProvider.logout().then((value) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'Login', (Route<dynamic> route) => false,
                                arguments: 2);
                          })),
                  SizedBox(
                    height: context.mqh * 0.06,
                  )
                ],
              ),
            )
          ]),
    );
  }
}
