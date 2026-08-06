/// Yeh ek notification ka model hai
/// Isme notification ka data hota hai - title, message, time, type
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'sms', 'email', 'order', etc
  final DateTime timestamp;
  final bool isSent; // Kya API ko bhej diya?

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isSent = false,
  });

  /// Notification ko Map mein convert karo (API ko bhejne ke liye)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'isSent': isSent,
    };
  }

  /// Copy with new values (jab update karna ho)
  NotificationModel copyWith({
    bool? isSent,
  }) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      isSent: isSent ?? this.isSent,
    );
  }
}
