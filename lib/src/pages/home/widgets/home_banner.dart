import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../app_assets.dart';
import '../../../components/primary_nosized_button.dart';
import '../../../components/shadow_box.dart';
import '../../../helpers/app_config.dart';
import '../../../models/order.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
        color: context.colorScheme.secondary,
        hMargin: context.mqw * 0.08,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.mqw * 0.83,
            maxHeight: context.mqh * 0.2,
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: context.mqw * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scopri subito\nle Tac offerte!",
                          style: context.textTheme.subtitle1?.copyWith(
                              color: const Color(0XFFFFFFFF), fontSize: 24),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        PrimaryNoSizedButton(
                            label: "SCOPRI ORA",
                            onPressed: () {
                              print(categories['restaurant']
                                  .toString()); // TODO offerte tac
                            },
                            height: 33)
                      ],
                    ),
                  )),
              Expanded(
                //TODO img associata a ogni diversa categoria
                flex: 2,
                child: Center(
                  child: Image.asset('assets/immagini_pharma/Banner.png',
                      width: context.mqw * 0.29, height: context.mqw * 0.29),
                ),
              )
            ],
          ),
        ));
  }
}
