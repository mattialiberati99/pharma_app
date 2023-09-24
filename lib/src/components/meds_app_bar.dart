import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/app_config.dart';
import '../providers/notification_provider.dart';

class MedsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(237);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationProv = ref.watch(notificationProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Container(
          height: 237,
          margin: const EdgeInsets.only(top: 30),
          child: ListView(
            children: [
              Column(
                textDirection: TextDirection.rtl,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width - 130,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
                          child: const Image(
                            width: 19.6,
                            height: 14,
                            image:
                                AssetImage('assets/immagini_pharma/menu.png'),
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 40),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('Notifiche');
                            notificationProv.nuovaNotifica = false;
                          },
                          child: notificationProv.nuovaNotifica
                              ? const Image(
                                  width: 24,
                                  height: 24,
                                  image: AssetImage(
                                      'assets/immagini_pharma/icon_noti.png'),
                                )
                              : const Image(
                                  width: 24,
                                  height: 24,
                                  image: AssetImage(
                                      'assets/immagini_pharma/bell.png'),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: const Text(
                        'Le mie medicine',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
