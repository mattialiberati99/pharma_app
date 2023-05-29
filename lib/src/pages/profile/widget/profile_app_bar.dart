import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/helpers/extensions.dart';
import 'package:pharma_app/src/pages/profile/widget/pickImage.dart';
import 'package:pharma_app/src/providers/cart_provider.dart';

import '../../../helpers/app_config.dart';
import '../../../providers/user_provider.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size? myPreferredSize;
  final String title;

  const ProfileAppBar({
    Key? key,
    required this.title,
    this.myPreferredSize,
  }) : super(key: key);

  void _pick(File image) {}

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
                  onTap: () => Navigator.pop(context),
                  child: const Image(
                      width: 19.6,
                      height: 14,
                      image: AssetImage('assets/immagini_pharma/menu.png'))),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
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
                            currentUser.value.name ?? 'Tac User',
                            style: context.textTheme.subtitle1
                                ?.copyWith(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
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
