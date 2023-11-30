import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/profile/widget/pickImage.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';
import '../../../../main.dart';
import '../../../repository/user_repository.dart' as userRepo;

import '../../../helpers/app_config.dart';
import '../../../providers/user_provider.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size? myPreferredSize;
  final String title;
  final AdvancedDrawerController advancedDrawerController;

  const ProfileAppBar({
    Key? key,
    required this.title,
    this.myPreferredSize,
    required this.advancedDrawerController,
  }) : super(key: key);

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    advancedDrawerController.showDrawer();
  }

  void _pick(File image) {
    /* currentUser.value.imagePath = image.path;
    logger.info(image.path);
    userRepo.addUserImage(); */
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Container(
        color: AppColors.primary,
        height: 237,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: GestureDetector(
                onTap: () => _handleMenuButtonPressed(),
                child: IconButton(
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: value.visible
                            ? Image(
                                image: const AssetImage(
                                    'assets/immagini_pharma/close.png'),
                                key: ValueKey<bool>(value.visible),
                              )
                            : Image(
                                width: 19.6,
                                height: 14,
                                image: const AssetImage(
                                    'assets/immagini_pharma/menu.png'),
                                key: ValueKey<bool>(value.visible),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentUser.value.name ?? 'Ospite',
                            style: context.textTheme.titleMedium
                                ?.copyWith(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PickImage(_pick),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(280);
}
