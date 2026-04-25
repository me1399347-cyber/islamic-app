// lib/data/datasources/local/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel
    const channel = AndroidNotificationChannel(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      description: 'تذكيرات إسلامية دورية',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - navigate to relevant screen
  }

  // ---- Show immediate notification ----
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      channelDescription: 'تذكيرات إسلامية',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }

  // ---- Schedule periodic reminder ----
  Future<void> schedulePeriodicReminder({
    required int id,
    required String message,
    required int intervalMinutes,
  }) async {
    await cancelReminder(id);

    // Use WorkManager for background tasks
    await Workmanager().registerPeriodicTask(
      'reminder_$id',
      'islamicReminder',
      frequency: Duration(minutes: intervalMinutes),
      inputData: {
        'id': id,
        'message': message,
        'title': '🤲 تذكير إسلامي',
      },
      constraints: Constraints(
        networkType: NetworkType.not_required,
      ),
    );
  }

  // ---- Cancel reminder ----
  Future<void> cancelReminder(int id) async {
    await _notifications.cancel(id);
    await Workmanager().cancelByUniqueName('reminder_$id');
  }

  // ---- Cancel all reminders ----
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
    await Workmanager().cancelAll();
  }

  // ---- Request permissions ----
  Future<bool> requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    bool? androidGranted = await android?.requestNotificationsPermission();
    bool? iosGranted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return androidGranted ?? iosGranted ?? false;
  }
}

// ---- WorkManager callback (top-level function) ----
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'islamicReminder' && inputData != null) {
      final service = NotificationService();
      await service.initialize();
      await service.showNotification(
        id: inputData['id'],
        title: inputData['title'] ?? '🤲 تذكير إسلامي',
        body: inputData['message'] ?? 'سبحان الله وبحمده',
      );
    }
    return Future.value(true);
  });
}
