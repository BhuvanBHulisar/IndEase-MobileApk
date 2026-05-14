import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/notification_model.dart';
import 'colors.dart';

const List<String> machineTypes = [
  'CNC',
  'Hydraulic Press',
  'Electric Motor',
  'Generator',
  'Lathe',
  'Other',
];

final List<ChatThread> mockChatThreads = [
  const ChatThread(
    id: '1',
    expertName: 'Rajesh K.',
    machineName: 'Main CNC',
    lastMessage: 'Will replace both bearings and test the spindle.',
    timeAgo: '2h ago',
    unreadCount: 1,
    accentColor: AppColors.secondary,
    status: 'In Progress',
  ),
  const ChatThread(
    id: '2',
    expertName: 'Suresh M.',
    machineName: 'Hydraulic Press',
    lastMessage: 'I can come tomorrow',
    timeAgo: '1d ago',
    unreadCount: 0,
    accentColor: AppColors.primary,
    status: 'In Progress',
  ),
];

final Map<String, List<ChatMessage>> mockChatMessages = {
  '1': const [
    ChatMessage(
      id: 'm1',
      threadId: '1',
      text: 'I\'ve reviewed your video. Looks like bearing failure.',
      time: '10:12 AM',
      isConsumer: false,
    ),
    ChatMessage(
      id: 'm2',
      threadId: '1',
      text: 'How long will the repair take?',
      time: '10:14 AM',
      isConsumer: true,
    ),
    ChatMessage(
      id: 'm3',
      threadId: '1',
      text: 'About 3 hours on-site. I can come 2 May morning.',
      time: '10:16 AM',
      isConsumer: false,
    ),
    ChatMessage(
      id: 'm4',
      threadId: '1',
      time: '10:18 AM',
      isConsumer: false,
      type: ChatMessageType.invoice,
      amount: 3300,
    ),
    ChatMessage(
      id: 'm5',
      threadId: '1',
      text: 'Thank you!',
      time: '10:20 AM',
      isConsumer: true,
    ),
    ChatMessage(
      id: 'm6',
      threadId: '1',
      time: '10:22 AM',
      isConsumer: false,
      type: ChatMessageType.appointment,
      appointmentDate: '2 May',
      appointmentTime: 'Morning',
      appointmentStatus: 'Confirmed',
    ),
  ],
  '2': const [
    ChatMessage(
      id: 'm7',
      threadId: '2',
      text: 'I can come tomorrow',
      time: '4:10 PM',
      isConsumer: false,
    ),
    ChatMessage(
      id: 'm8',
      threadId: '2',
      text: 'Please do. The line is slowing production.',
      time: '4:14 PM',
      isConsumer: true,
    ),
  ],
};

final List<NotificationModel> mockNotifications = [
  const NotificationModel(
    id: 'n1',
    title: 'Quote Received',
    message: 'Rajesh sent a quote of ₹3,300',
    timeAgo: '2h ago',
    icon: Icons.notifications_rounded,
    color: AppColors.secondary,
    isRead: false,
  ),
  const NotificationModel(
    id: 'n2',
    title: 'Expert Confirmed',
    message: 'Your quote was approved',
    timeAgo: '1d ago',
    icon: Icons.verified_rounded,
    color: AppColors.success,
    isRead: true,
  ),
  const NotificationModel(
    id: 'n3',
    title: 'New Message',
    message: 'Rajesh: Will replace both bearings...',
    timeAgo: '3h ago',
    icon: Icons.chat_bubble_rounded,
    color: AppColors.primary,
    isRead: false,
  ),
  const NotificationModel(
    id: 'n4',
    title: 'Payment Successful',
    message: '₹3,300 payment processed',
    timeAgo: '2d ago',
    icon: Icons.payments_rounded,
    color: AppColors.warning,
    isRead: true,
  ),
];
