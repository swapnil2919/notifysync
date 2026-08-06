import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';
import 'api_service.dart';

/// Notifications ko capture aur handle karna
class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notifications ka list (app mein store karte hain)
  static List<NotificationModel> capturedNotifications = [];

  // Counting notifications
  static int totalCaptured = 0;
  static int totalSynced = 0;

  /// Initialize notifications
  static Future<void> initialize() async {
    print('🔧 Initializing Notifications...');

    // Android settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    // Combine karo
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // Initialize karo
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('📲 Notification tapped: ${response.payload}');
      },
    );

    print('✅ Notifications initialized');
  }

  /// Notification capture karo (jab new notification aaye)
  static void captureNotification(NotificationModel notification) {
    print('📍 Capturing: ${notification.title}');

    // List mein add karo
    capturedNotifications.insert(0, notification);
    totalCaptured++;

    // API ko bheejo
    sendToApi(notification);
  }

  /// Notification ko API ko bheejo
  static Future<void> sendToApi(NotificationModel notification) async {
    try {
      bool success = await ApiService.sendNotificationToApi(notification);

      if (success) {
        // Notification ko isSent = true mark karo
        int index = capturedNotifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          capturedNotifications[index] = capturedNotifications[index].copyWith(
            isSent: true,
          );
          totalSynced++;
        }
      }
    } catch (e) {
      print('❌ Error in sendToApi: $e');
    }
  }

  /// Show local notification (testing ke liye)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'notification_channel_id',
      'Notifications',
      channelDescription: 'Channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Show notification
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: type,
    );

    // Capture bhi karo
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: body,
      type: type,
      timestamp: DateTime.now(),
      isSent: false,
    );

    captureNotification(notification);
  }

  /// Statistics get karo
  static Map<String, int> getStats() {
    return {
      'total_captured': totalCaptured,
      'total_synced': totalSynced,
      'pending': totalCaptured - totalSynced,
    };
  }

  /// Clear all notifications
  static void clearAll() {
    capturedNotifications.clear();
    totalCaptured = 0;
    totalSynced = 0;
    print('🗑️ All notifications cleared');
  }
}
