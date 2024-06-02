import 'package:flutter/material.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('This is the Profile Screen'),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}