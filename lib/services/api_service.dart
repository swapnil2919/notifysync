import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notification_model.dart';

/// API ke sath communicate karna
class ApiService {
  // Dummy API URL (abhi sirf example hai)
  static const String baseUrl = 'http://localhost:8000/api';

  // User ID (settings se ayega)
  static String userId = 'user123';

  /// Notification ko API ko bhejo
  static Future<bool> sendNotificationToApi(NotificationModel notification) async {
    try {
      print('📤 Sending notification: ${notification.title}');

      // Request body banao
      final body = jsonEncode({
        'user_id': userId,
        'title': notification.title,
        'message': notification.message,
        'type': notification.type,
        'timestamp': notification.timestamp.toIso8601String(),
      });

      // POST request bheejo
      final response = await http.post(
        Uri.parse('$baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ Request timeout');
          return http.Response('timeout', 408);
        },
      );

      // Response check karo
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Notification sent successfully');
        return true;
      } else {
        print('❌ Failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('🔴 Error sending notification: $e');
      return false;
    }
  }

  /// Sab notifications fetch karo API se
  static Future<List<NotificationModel>> getNotifications() async {
    try {
      print('📥 Fetching notifications...');

      final response = await http.get(
        Uri.parse('$baseUrl/notifications?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ Request timeout');
          return http.Response('timeout', 408);
        },
      );

      if (response.statusCode == 200) {
        print('✅ Notifications fetched');

        // JSON parse karo
        final List<dynamic> data = jsonDecode(response.body);

        // NotificationModel list banao
        return data.map((item) {
          return NotificationModel(
            id: item['id'].toString(),
            title: item['title'],
            message: item['message'],
            type: item['type'] ?? 'unknown',
            timestamp: DateTime.parse(item['timestamp']),
            isSent: item['isSent'] ?? true,
          );
        }).toList();
      } else {
        print('❌ Failed to fetch: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🔴 Error fetching notifications: $e');
      return [];
    }
  }

  /// Dummy notification banao (testing ke liye)
  static NotificationModel createDummyNotification(String type) {
    final now = DateTime.now();

    Map<String, Map<String, String>> dummyData = {
      'sms': {
        'title': 'SMS Alert',
        'message': 'Your OTP is 123456',
      },
      'email': {
        'title': 'Email Notification',
        'message': 'Welcome to NotifySync!',
      },
      'order': {
        'title': 'Order Shipped',
        'message': 'Your order #12345 has been shipped',
      },
      'payment': {
        'title': 'Payment Received',
        'message': 'Payment of \$100 received successfully',
      },
      'delivery': {
        'title': 'Delivery Update',
        'message': 'Your package will arrive today',
      },
    };

    final data = dummyData[type] ?? dummyData['sms']!;

    return NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: data['title']!,
      message: data['message']!,
      type: type,
      timestamp: now,
      isSent: false,
    );
  }
}
