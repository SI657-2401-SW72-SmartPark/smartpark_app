import 'package:flutter/material.dart';
import 'package:smartpark_app/pages/login/login.dart';
import 'package:smartpark_app/pages/renter/booking.dart';
import 'package:smartpark_app/pages/renter/home.dart';
import 'package:smartpark_app/pages/renter/profile.dart'; // Importa la pantalla de perfil cuando esté implementada

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
        '/reservations': (context) => const ReservationsScreen(),
        '/profile': (context) => const ProfileScreen(), // Define la pantalla de perfil cuando esté implementada
      },
    );
  }
}