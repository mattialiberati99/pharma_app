import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharma_app/src/components/primary_nosized_button.dart';
import 'package:pharma_app/src/helpers/extensions.dart';

import '../../../generated/l10n.dart';
import '../../components/custom_app_bar.dart';
import '../../helpers/app_config.dart';
import '../../models/route_argument.dart';

class TrackingWidget extends ConsumerWidget {
  TrackingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final theme = Theme.of(context)!.copyWith(dividerColor: Colors.transparent, accentColor: Theme.of(context).accentColor);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Traccia ordine',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: RefreshIndicator(
          onRefresh: () async {}, //_refresh,
          child: ListView(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'MM09130520',
                    style: ExtraTextStyles.mediumSmallBlackBold,
                  ),
                ),
                Expanded(
                  child: Text(
                    '1-3 ORE',
                    style: ExtraTextStyles.mediumSmallBlackBold,
                  ),
                ),
                Expanded(
                  child: Text(
                    '1 Kg',
                    style: ExtraTextStyles.mediumSmallBlackBold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Numero di tracciamento',
                    style: ExtraTextStyles.smallGrey,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tempo stimato',
                    style: ExtraTextStyles.smallGrey,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Peso del pacco',
                    style: ExtraTextStyles.smallGrey,
                  ),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 1,
              color: AppColors.gray5,
            ),
            Opacity(
              opacity: 1,
              /*order.orderStatus!.id! <
                          OrderStatus.annullato &&
                      order.orderStatus!.id! >= OrderStatus.accepted
                  ? 1.0
                  : 0.3,*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/ico/record-circle.svg',
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    'Inviato',
                    style: ExtraTextStyles.normalBlackBold,
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 1,
              /*
                  order.orderStatus!.id! < OrderStatus.annullato &&
                          order.orderStatus!.id! >=
                              OrderStatus.in_delivery
                      ? 1.0
                      : 0.3,*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/ico/record-circle.svg',
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    'In transito',
                    style: ExtraTextStyles.normalBlackBold,
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 1,
              /*
                  order.orderStatus!.id! == OrderStatus.delivered
                      ? 1.0
                      : 0.3,*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/ico/record-circle.svg',
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    'In consegna',
                    style: ExtraTextStyles.normalBlackBold,
                    //textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            //if(order.orderStatus!.id! == OrderStatus.annullato)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(
                  Icons.pin_drop,
                  color: AppColors.secondDarkColor,
                ),
                title: Text(
                  'Consegnato',
                  style: ExtraTextStyles.normalBlackBold,
                  //textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: context.mqh * 0.25,
            ),
            PrimaryNoSizedButton(
                label: 'TORNA AGLI ACQUISTI',
                onPressed: () => {
                      Navigator.pop(context),
                      Navigator.pop(context),
                      Navigator.pop(context),
                    },
                height: 60)
          ]),
        ),
      ),
    ); //:CircularLoadingWidget(height: 500);
  }
}
