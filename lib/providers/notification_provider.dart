import 'package:flutter/foundation.dart';

import '../constants/mock_data.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications =
      List<NotificationModel>.from(mockNotifications);

  List<NotificationModel> get notifications =>
      List<NotificationModel>.unmodifiable(_notifications);

  int get unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  void markAllRead() {
    for (var index = 0; index < _notifications.length; index++) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
    notifyListeners();
  }
}
