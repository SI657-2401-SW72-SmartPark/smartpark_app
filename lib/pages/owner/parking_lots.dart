import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpark_app/pages/owner/parking_lots_detail.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';
import 'package:smartpark_app/pages/owner/add_parking_lot.dart';

class ParkingLotsScreen extends StatefulWidget {
  const ParkingLotsScreen({Key? key});

  @override
  State<ParkingLotsScreen> createState() => _ParkingLotsScreenState();
}

class _ParkingLotsScreenState extends State<ParkingLotsScreen> {
  late List<dynamic> _parkinglots;
  late int _userId;

  @override
  void initState() {
    super.initState();
    _parkinglots = [];
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('id')!;
    });
    _getParkinglots();
  }

  Future<void> _getParkinglots() async {
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/zona_aparcamiento/todos"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _parkinglots = data.where((parkinglot) => parkinglot['usuario'].toString() == _userId.toString()).toList();
      });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Estacionamientos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParkingLot(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _parkinglots.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: _parkinglots.length,
          itemBuilder: (context, index) {
            var parkinglot = _parkinglots[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingLotsDetailScreen(id: parkinglot['id']),
                  ),
                );
              },
              child: ParkingLotsCard(
                title: parkinglot['nombre'],
                address: parkinglot['direccion'],
                date: '19-01-2022', // Ajustar según los datos reales
                time: 'De 9:30 PM a 11:00 PM', // Ajustar según los datos reales
                status: 'Activo', // Ajustar según los datos reales
                imageUrl: parkinglot['imagen'],
                onDelete: () {
                  // Lógica para eliminar el estacionamiento si es necesario
                },
                onEdit: () {
                  // Lógica para editar el estacionamiento si es necesario
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

class ParkingLotsCard extends StatelessWidget {
  final String title;
  final String address;
  final String date;
  final String time;
  final String status;
  final String imageUrl;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ParkingLotsCard({
    Key? key,
    required this.title,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.imageUrl,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    address,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      SizedBox(width: 5),
                      Text(date),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      SizedBox(width: 5),
                      Text(time),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.radio_button_checked, color: status == 'Activo' ? Colors.green : Colors.red),
                      SizedBox(width: 5),
                      Text(status),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: onDelete,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}