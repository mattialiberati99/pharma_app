import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/app_assets.dart';

import '../providers/user_provider.dart';
import 'button_social_border.dart';

class SocialLogin extends ConsumerWidget {
  final double margin;

  const SocialLogin({Key? key, required this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProv = ref.watch(userProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonSocial(
            logoPath: AppAssets.logoGoogle,
            borderColor: Colors.transparent,
            onTap: () => userProv.loginGoogle(context),
          ),
          ButtonSocial(
            logoPath: 'assets/ico/fb.svg',
            borderColor: Colors.transparent,
            onTap: () => userProv.signInWithFacebook(context),
          )
        ],
      ),
    );
  }
}
