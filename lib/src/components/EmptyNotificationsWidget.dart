import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'empty_widget.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      text: S.of(context).dont_have_any_item_in_the_notification_list,
      icon: Icons.notifications,
      textStyle: Theme.of(context).textTheme.headline4!,
      action: Container(),
      // MaterialButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed('/Pages', arguments: 2);
      //   },
      //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      //   color: Theme.of(context).primaryColorDark,
      //   shape: StadiumBorder(),
      //   child: Text(
      //     S.of(context).start_exploring,
      //     style: Theme.of(context).textTheme.headline6,
      //   ),
      // )
    );
  }
}
