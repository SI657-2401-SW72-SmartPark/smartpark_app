import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smartpark_app/pages/renter/reservation_detail.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late List<dynamic> _reservations;

  @override
  void initState() {
    super.initState();
    _reservations = [];
    _getReservations();
  }

  Future<void> _getReservations() async {
    var url = Uri.parse("https://modest-education-production.up.railway.app/api/v1/reserva/todos");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _reservations = data as List<dynamic>;
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Reservas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _reservations.length,
          itemBuilder: (context, index) {
            var reservation = _reservations[index];
            // Extracting start time and hours from the reservation data
            var inicioReserva = DateTime.parse(reservation['inicioReserva']);
            var horas = reservation['horas'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetailScreen(id: reservation['id']),
                  ),
                );
              },
              child: ReservationCard(
                title: 'Reserva ${reservation['id']}',
                startTime: inicioReserva,
                hours: horas,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String title;
  final DateTime startTime;
  final int hours;
  final String address; // Assuming you have an address field in your data model

  const ReservationCard({
    Key? key,
    required this.title,
    required this.startTime,
    required this.hours,
    this.address = '', // Provide a default value for address
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormatter = DateFormat('yyyy-MM-dd HH:mm'); // Adjust format as needed

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title ?? 'No title available', // Use a placeholder if title is null
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Icon(Icons.calendar_today),
                SizedBox(width: 5),
                Text(dateFormatter.format(startTime)), // Formatting start time
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text('$hours horas'),
              ],
            ),
            SizedBox(height: 10),
            Text(
              address ?? 'No address available', // Use a placeholder if address is null
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}