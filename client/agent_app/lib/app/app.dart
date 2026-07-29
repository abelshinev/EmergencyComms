import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

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
      home: const HomeScreen(),
    );
  }
}