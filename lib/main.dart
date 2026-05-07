import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/request_provider.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  final authProvider = AuthProvider();
  final requestProvider = RequestProvider();
  final notificationProvider = NotificationProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<RequestProvider>.value(value: requestProvider),
        ChangeNotifierProvider<NotificationProvider>.value(
          value: notificationProvider,
        ),
      ],
      child: IndEaseApp(authProvider: authProvider),
    ),
  );
}
