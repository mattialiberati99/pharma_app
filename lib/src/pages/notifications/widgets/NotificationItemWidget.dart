import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../generated/l10n.dart';
import '../../../helpers/app_config.dart';
import '../../../helpers/helper.dart';
import '../../../models/notification.dart' as model;

class NotificationItemWidget extends StatelessWidget {
  final model.Notification notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnRead;
  final VoidCallback onRemoved;
  final VoidCallback onTap;

  NotificationItemWidget(
      {Key? key,
      required this.notification,
      required this.onMarkAsRead,
      required this.onMarkAsUnRead,
      required this.onRemoved,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(notification.id ?? '0'),
        onDismissed: (dir) {
          onRemoved();
        },
        direction: DismissDirection.horizontal,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(244, 246, 245, 1), width: 10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                        'assets/immagini_pharma/logo_notifiche.png'),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                              // TODO: FINIRE NOTIFICHE 25/08/23
                              'prova'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /* child: Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (notification.data["image_url"] != null)
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: notification.data["image_url"],
                          fit: BoxFit.fitHeight,
                          placeholder: (context, i) => ClipRRect(
                            child: Image.asset(
                              'assets/immagini/loading.gif',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      //width: MediaQuery.of(context).size.width-150,
                      //padding: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.data["title"] ?? "No Title",
                              style: ExtraTextStyles.smallBlackBold,
                              textAlign: TextAlign.start,
                            ),
                            Flexible(
                              child: Text(
                                notification.data["body"] ??
                                    "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                                style: ExtraTextStyles.smallGrey,
                                maxLines: 2,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                if (!notification.read!)
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Unread",
                        style: ExtraTextStyles.normalAccent,
                      ))
              ],
            ), */
          ),
        ));
  }
}
