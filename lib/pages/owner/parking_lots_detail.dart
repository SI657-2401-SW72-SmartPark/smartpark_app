import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpark_app/models/parking_lot.dart';

class ParkingLotsDetailScreen extends StatelessWidget {
  final int id;
  ParkingLotsDetailScreen({required this.id, Key? key}) : super(key: key);

  Future<ParkingLot> getParkingLotDetail(int id) async {
    var response = await http.get(Uri.https("dummyjson.com", 'products/$id'));
    var parkingLotData = jsonDecode(response.body);

    return ParkingLot(
      parkingLotData["id"],
      parkingLotData["title"],
      parkingLotData["description"],
      parkingLotData["images"][0],
      parkingLotData["price"].toInt(),
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
        future: getParkingLotDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            ParkingLot? parkingLot = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Text(
                        parkingLot!.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 5),
                      Text('Av. Alameda sur 185 Chorrillos'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 5),
                      Text('19-01-2022'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 5),
                      Text('De 9:30 PM a 11:00 PM'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 5),
                      Text('2:00 Hours'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 5),
                      Text('\$${parkingLot.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.directions_car),
                      SizedBox(width: 5),
                      Text('PCS-123'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Descripcion:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(parkingLot.description),
                  SizedBox(height: 20),
                  Image.network(parkingLot.imageUrl),
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