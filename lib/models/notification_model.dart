import 'package:flutter/material.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.color,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final bool isRead;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? timeAgo,
    IconData? icon,
    Color? color,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timeAgo: timeAgo ?? this.timeAgo,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isRead: isRead ?? this.isRead,
    );
  }
}
