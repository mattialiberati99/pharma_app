import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../../main.dart' as app;
import '../../helpers/app_config.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelGroupKey: 'high_importance_channel',
          channelName: 'Terapie',
          channelDescription: 'Notification channel for terapie',
          defaultColor: AppColors.primary,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreateMethod,
      onNotificationDisplayedMethod: onNotificationDisplayMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  // Use this method to detected when a new notification or a schedule is created
  static Future<void> onNotificationCreateMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreateMethod');
  }

  // Use this method to detected every time that a new notification is displayed
  static Future<void> onNotificationDisplayMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayMethod');
  }

  // Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  // Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionRecivedMethod');
    final payload = receivedAction.payload ?? {};
    /* if (payload["navigate"] == "true") {
      app.navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => const Pagina(),
      ));
    } */
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    required DateTime scheduleTime,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        wakeUpScreen: true,
        autoDismissible: false,
        
      ),
      actionButtons: actionButtons,
      
      
      schedule: NotificationCalendar.fromDate(date: scheduleTime),
    );
    
  }
}
