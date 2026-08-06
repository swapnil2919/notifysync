import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

/// Captured notifications ko display karna
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured notifications'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[900]!,
              Colors.teal[700]!,
            ],
          ),
        ),
        child: NotificationService.capturedNotifications.isEmpty
            ? _emptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: NotificationService.capturedNotifications.length,
                itemBuilder: (context, index) {
                  final notification =
                      NotificationService.capturedNotifications[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: notification.isSent
                            ? Colors.green[400]!
                            : Colors.orange[400]!,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Title aur Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon based on type
                            _getTypeIcon(notification.type),
                            const SizedBox(width: 12),

                            // Title aur message
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    notification.message,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue[100],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: notification.isSent
                                    ? Colors.green[400]?.withOpacity(0.2)
                                    : Colors.orange[400]?.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    notification.isSent
                                        ? Icons.check_circle
                                        : Icons.schedule,
                                    size: 12,
                                    color: notification.isSent
                                        ? Colors.green[400]
                                        : Colors.orange[400],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    notification.isSent ? 'Sent' : 'Pending',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: notification.isSent
                                          ? Colors.green[400]
                                          : Colors.orange[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Footer: Type aur timestamp
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[400]?.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                notification.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue[300],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat('HH:mm:ss')
                                  .format(notification.timestamp),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue[200],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Empty state
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            color: Colors.blue[300],
            size: 60,
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[100],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Notifications will appear here once they are captured',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[200],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get icon based on notification type
  Widget _getTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'sms':
        icon = Icons.message;
        color = Colors.blue[300]!;
        break;
      case 'email':
        icon = Icons.mail;
        color = Colors.purple[300]!;
        break;
      case 'order':
        icon = Icons.shopping_bag;
        color = Colors.orange[300]!;
        break;
      case 'payment':
        icon = Icons.payment;
        color = Colors.green[300]!;
        break;
      case 'delivery':
        icon = Icons.local_shipping;
        color = Colors.cyan[300]!;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.blue[300]!;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}
