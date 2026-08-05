import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

class StationAlertsApp extends StatelessWidget {
  const StationAlertsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Passenger',
      home: const HomeScreen(),
    );
  }
}