import 'package:flutter/material.dart';

enum ChatMessageType { text, invoice, appointment }

class ChatThread {
  const ChatThread({
    required this.id,
    required this.expertName,
    required this.machineName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.accentColor,
    required this.status,
  });

  final String id;
  final String expertName;
  final String machineName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final Color accentColor;
  final String status;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.time,
    required this.isConsumer,
    this.text,
    this.type = ChatMessageType.text,
    this.amount,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentStatus,
  });

  final String id;
  final String threadId;
  final String? text;
  final String time;
  final bool isConsumer;
  final ChatMessageType type;
  final int? amount;
  final String? appointmentDate;
  final String? appointmentTime;
  final String? appointmentStatus;
}
