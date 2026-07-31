import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class StationAlertsApp extends StatelessWidget {
  const StationAlertsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passenger',
      home: const HomeScreen(),
    );
  }
}