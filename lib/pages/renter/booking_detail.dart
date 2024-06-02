import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpark_app/models/parking_lot.dart';

class ReservationDetailScreen extends StatelessWidget {
  final int id;
  ReservationDetailScreen({required this.id, Key? key}) : super(key: key);

  Future<ParkingLot> getReservationDetail(int id) async {
    var response = await http.get(Uri.https("dummyjson.com", 'products/$id'));
    var reservationData = jsonDecode(response.body);

    return ParkingLot(
      reservationData["id"],
      reservationData["title"],
      reservationData["description"],
      reservationData["images"][0],
      reservationData["price"].toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<ParkingLot>(
        future: getReservationDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            ParkingLot? reservation = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    reservation!.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 5),
                      Text('Av. Alameda sur 185 Chorrillos'), // Usar datos reales de la reserva
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 5),
                      Text('19-01-2022'), // Usar datos reales de la reserva
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 5),
                      Text('De 9:30 PM a 11:00 PM'), // Usar datos reales de la reserva
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 5),
                      Text('2:00 Hours'), // Usar datos reales de la reserva
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 5),
                      Text('\$${reservation.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.directions_car),
                      SizedBox(width: 5),
                      Text('PCS-123'), // Usar datos reales de la reserva
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Descripcion:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(reservation.description),
                  SizedBox(height: 20),
                  Image.network(reservation.imageUrl),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
