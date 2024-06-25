import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReservationDetailScreen extends StatelessWidget {
  final int id;

  ReservationDetailScreen({required this.id, Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getReservationDetail(int id) async {
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/reserva/$id"));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getVehicleDetail(int? vehicleId) async {
    if (vehicleId == null) {
      return {};
    }
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/vehiculo/$vehicleId"));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getVehicleType(int? typeId) async {
    if (typeId == null) {
      return {};
    }
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/tipo_vehiculo/$typeId"));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de Reserva"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getReservationDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var reservationData = snapshot.data!;
          var startTime = DateTime.tryParse(reservationData['inicioReserva'] ?? '');
          var hours = reservationData['horas'] ?? 0;
          var vehicleId = reservationData['vehiculo'];

          return FutureBuilder<Map<String, dynamic>>(
            future: getVehicleDetail(vehicleId),
            builder: (context, vehicleSnapshot) {
              if (vehicleSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (vehicleSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${vehicleSnapshot.error}'),
                );
              }

              var vehicleData = vehicleSnapshot.data ?? {};
              var vehiclePlate = vehicleData['placa'] ?? 'Placa no disponible';
              var vehicleBrand = vehicleData['marca'] ?? 'Marca no disponible';
              var vehicleTypeId = vehicleData['tipoVehiculo'];

              return FutureBuilder<Map<String, dynamic>>(
                future: getVehicleType(vehicleTypeId),
                builder: (context, typeSnapshot) {
                  if (typeSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (typeSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${typeSnapshot.error}'),
                    );
                  }

                  var vehicleType = typeSnapshot.data?['tipo'] ?? 'Tipo de vehículo no disponible';

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Reserva ${reservationData["id"]}',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 5),
                            Text(startTime != null ? DateFormat('dd-MM-yyyy').format(startTime) : 'Fecha no disponible'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.timer),
                            SizedBox(width: 5),
                            Text('$hours horas'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.directions_car),
                            SizedBox(width: 5),
                            Text(vehiclePlate),
                            SizedBox(width: 10),
                            Text(vehicleBrand),
                            SizedBox(width: 10),
                            Text(vehicleType),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Descripción:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(reservationData['description'] ?? 'No se encontró descripción'),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}