import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Principal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_parking),
          label: 'Estacionamientos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Reservaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: _getSelectedIndex(context),
      selectedItemColor: Colors.blue, // Color de ícono y texto activo
      unselectedItemColor: Colors.black, // Color de ícono y texto inactivo
      onTap: (index) {
        _onItemTapped(index, context);
      },
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case '/home':
        return 0;
      case '/parking':
        return 1;
      case '/reservations':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/parking');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/reservations');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}