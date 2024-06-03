import 'package:flutter/material.dart';
import 'package:smartpark_app/pages/login/login.dart';
import 'package:smartpark_app/pages/owner/parking_lots.dart';
import 'package:smartpark_app/pages/renter/booking.dart';
import 'package:smartpark_app/pages/shared/home.dart';
import 'package:smartpark_app/pages/shared/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartPark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/parking': (context) => const ParkingLotsScreen(),
        '/reservations': (context) => const ReservationsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}