import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class StationAlertsApp extends StatelessWidget {
  const StationAlertsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StationAlerts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      navigatorKey: navigatorKey,
      home: const HomeScreen(),
    );
  }
}