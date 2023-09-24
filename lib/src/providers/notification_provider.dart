import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/notification_repository.dart';
import '../models/notification.dart' as model;

final notificationProvider =
    ChangeNotifierProvider<NotificationProvider>((ref) {
  return NotificationProvider();
});

class NotificationProvider with ChangeNotifier {
  List<model.Notification> notifications = [];
  bool nuovaNotifica = false;

  NotificationProvider() {
    Future.delayed(Duration.zero, () async {
      notifications.addAll(await getNotifications());
      nuovaNotifica = true;
      notifyListeners();
    });
  }

  setRead(model.Notification notification) {
    notification.read = true;
    nuovaNotifica = false;
    markAsReadNotifications(notification);
    notifyListeners();
  }

  delete(model.Notification notification) {
    notifications.remove(notification);
    nuovaNotifica = false;
    removeNotification(notification);
    notifyListeners();
  }

  deleteAll() {
    for (model.Notification not in notifications) {
      notifications.remove(not);
      removeNotification(not);
    }
    notifyListeners();
  }

  get unread => notifications.where((element) => element.read!);

  Future<void> refreshNotifications() async {
    notifications.clear;
    notifications.addAll(await getNotifications());
    return;
  }
}
