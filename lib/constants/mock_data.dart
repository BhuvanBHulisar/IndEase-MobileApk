import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/machine_model.dart';
import '../models/notification_model.dart';
import '../models/quote_model.dart';
import '../models/request_model.dart';
import 'colors.dart';

const String mockUserFirstName = 'Amit';
const String mockUserLastName = 'Kumar';
const String mockUserEmail = 'amit@example.com';
const String demoEmail = 'demo@consumer.com';
const String demoPassword = 'demo123';

const List<String> machineTypes = [
  'CNC',
  'Hydraulic Press',
  'Electric Motor',
  'Generator',
  'Lathe',
  'Other',
];

final List<MachineModel> mockMachines = [
  const MachineModel(
    id: '1',
    name: 'Main CNC Milling Unit',
    type: 'CNC Concentric',
    year: 1990,
  ),
  const MachineModel(
    id: '2',
    name: 'Hydraulic Press #2',
    type: 'Hydraulic Press',
    year: 2005,
  ),
  const MachineModel(
    id: '3',
    name: 'Motor Assembly Line',
    type: 'Electric Motor',
    year: 2012,
  ),
];

final List<RequestModel> mockRequests = [
  const RequestModel(
    id: '1',
    machineId: '1',
    machineName: 'Main CNC Milling Unit',
    machineType: 'CNC Machine',
    issue: 'Strange grinding noise from spindle',
    status: 'quote_submitted',
    updatedAt: '2 hrs ago',
    expertName: 'Rajesh K.',
  ),
  const RequestModel(
    id: '2',
    machineId: '2',
    machineName: 'Hydraulic Press #2',
    machineType: 'Hydraulic Press',
    issue: 'Pressure valve leaking',
    status: 'in_progress',
    updatedAt: '1 day ago',
    expertName: 'Suresh M.',
    urgency: 'Critical',
    preferredDate: '3 May',
    preferredSlot: 'Afternoon',
    budgetHint: '₹3,000 – ₹6,000',
    aiMachineType: 'Hydraulic Press',
    aiIssue: 'Valve seal failure likely',
    aiConfidence: 0.81,
  ),
  const RequestModel(
    id: '3',
    machineId: '3',
    machineName: 'Motor Assembly Line',
    machineType: 'Electric Motor',
    issue: 'Belt slipping at high speed',
    status: 'broadcast',
    updatedAt: '3 hrs ago',
    urgency: 'Normal',
    preferredDate: '5 May',
    preferredSlot: 'Any time',
    budgetHint: '₹1,500 – ₹4,000',
    aiMachineType: 'Motor Assembly System',
    aiIssue: 'Drive belt wear detected',
    aiConfidence: 0.74,
  ),
];

final Map<String, List<QuoteModel>> mockQuotesByRequest = {
  '1': const [
    QuoteModel(
      id: 'q1',
      requestId: '1',
      expertName: 'Rajesh K. Sharma',
      rating: 5.0,
      level: 'Bronze',
      jobsDone: 3,
      diagnosisNote:
          'Based on the video, inner bearing race failure. Will replace both bearings and test.',
      scopeOfWork: 'Inspect → Replace bearings → Lubricate → Load test',
      labourCost: 2500,
      partsCost: 800,
      total: 3300,
      estimatedHours: 3,
      availableDate: '2 May',
      availableSlot: 'Morning',
      visitType: 'On-site',
    ),
    QuoteModel(
      id: 'q2',
      requestId: '1',
      expertName: 'Suresh Mehta',
      rating: 4.2,
      level: 'Starter',
      jobsDone: 1,
      diagnosisNote: 'Will inspect on-site and diagnose.',
      scopeOfWork: 'Initial inspection → Fault isolation → Repair plan → Final test',
      labourCost: 2400,
      partsCost: 0,
      total: 2400,
      estimatedHours: 4,
      availableDate: '3 May',
      availableSlot: 'Afternoon',
      visitType: 'On-site',
    ),
  ],
};

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
