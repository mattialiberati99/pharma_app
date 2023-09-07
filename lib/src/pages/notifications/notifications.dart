import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_app/src/components/custom_app_bar.dart';
import 'package:pharma_app/src/pages/notifications/widgets/NotificationItemWidget.dart';

import '../../components/EmptyNotificationsWidget.dart';
import '../../components/PermissionDeniedWidget.dart';
import '../../components/custom_app_bar_notifiche.dart';
import '../../models/route_argument.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification.dart' as Model;
import '../../providers/user_provider.dart';

class NotificationsWidget extends ConsumerWidget {
  final bool hideBack;

  const NotificationsWidget({super.key, this.hideBack = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifProv = ref.watch(notificationProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: const CustomAppBarNotifiche(title: "Notifiche"),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
              onRefresh: notifProv.refreshNotifications,
              child: notifProv.notifications.isEmpty
                  ? EmptyNotificationsWidget()
                  : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      children: <Widget>[
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: notifProv.notifications.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                          itemBuilder: (context, index) {
                            Model.Notification notification =
                                notifProv.notifications.elementAt(index);
                            return NotificationItemWidget(
                                notification: notification,
                                onMarkAsRead: () {
                                  notifProv.setRead(notification);
                                },
                                onMarkAsUnRead: () {},
                                onRemoved: () {
                                  notifProv.delete(notification);
                                },
                                onTap: () {
                                  notifProv.setRead(notification);
                                  Navigator.of(context).pushNamed(
                                      notification.data['screen'],
                                      arguments: RouteArgument(
                                          id: notification.data['id']
                                              .toString(),
                                          showFull: notification.data['full'] ??
                                              false));
                                });
                          },
                        ),
                      ],
                    )),
    );
  }
}

// class Notifications extends ConsumerWidget {
//   const Notifications({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return WillPopScope(
//       onWillPop: () async {
//         ref.read(selectedPageNameProvider.notifier).resetNavigation();
//         return false;
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: const CustomAppBar(title: "Notifiche",canPop: false,),
//         drawer: const AppDrawer(),
//         drawerEnableOpenDragGesture: true,
//         body: SafeArea(
//           child: SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //TODO stringa
//             const SizedBox(height: 20),
//           ],
//       ),
//           ),
//         ),
//       ),
//     );
//   }
// }

