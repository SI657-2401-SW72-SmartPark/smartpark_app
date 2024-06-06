import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpark_app/models/parking_lot.dart';
import 'package:smartpark_app/pages/renter/reserve_parking.dart';

class ParkingDetail extends StatelessWidget {
  final int id;
  ParkingDetail({required this.id, Key? key}) : super(key: key);

  Future<ParkingLot> getParkDetail(int id) async {
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/zona_aparcamiento/$id"));
    var parkingLotData = jsonDecode(response.body);

    return ParkingLot(
      parkingLotData["id"],
      parkingLotData["nombre"],
      parkingLotData["descripcion"],
      parkingLotData["imagen"],
      parkingLotData["numeroEstacionamiento"],
      parkingLotData["direccion"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles"),
      ),
      body: FutureBuilder<ParkingLot>(
        future: getParkDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            ParkingLot? parkingLot = snapshot.data;

            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(parkingLot!.imagen),
                ),
                scroll(parkingLot)
              ],
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

  Widget scroll(ParkingLot parkingLot) {
    return DraggableScrollableSheet(
      initialChildSize: 0.73,
      maxChildSize: 1.0,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 35,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  parkingLot.nombre,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_money),
                        SizedBox(width: 10),
                        Text(
                          "El precio hora o fraccion es de S/${parkingLot.numeroEstacionamiento}",
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined),
                        SizedBox(width: 10),
                        Text(
                          "Lun a Dom 9:00 a 22:00 hrs",
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Descripción: \n" + parkingLot.descripcion,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReserveParking()),
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.orange),
                      ),
                      child: const Text(
                        "Reservar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ParkingLot {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final int numeroEstacionamiento;
  final String direccion;

  ParkingLot(
      this.id,
      this.nombre,
      this.descripcion,
      this.imagen,
      this.numeroEstacionamiento,
      this.direccion,
      );
}