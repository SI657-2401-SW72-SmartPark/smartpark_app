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

  Future<List<Comment>> getCommentsWithUsers(int parkingLotId) async {
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/comentario/todos"));
    var commentData = jsonDecode(response.body) as List;

    var comments = commentData
        .where((comment) => comment['estacionamiento'] == parkingLotId)
        .map((comment) => Comment.fromJson(comment))
        .toList();

    var users = await getUsers();

    comments.forEach((comment) {
      var user = users.firstWhere((user) => user.id == comment.usuario);
      comment.setFullname(user.fullname);
    });

    return comments;
  }
  Future<List<User>> getUsers() async {
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/usuario/todos"));
    var userData = jsonDecode(response.body) as List;
    return userData.map((user) => User.fromJson(user)).toList();
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
        return FutureBuilder<List<Comment>>(
          future: getCommentsWithUsers(parkingLot.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              List<Comment>? comments = snapshot.data;

              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
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
                            "Descripción: \n" + parkingLot.direccion,
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
                          SizedBox(height: 20),
                          Text(
                            "Comentarios:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ...comments!.map((comment) => ListTile(
                            title: Text(comment.fullname),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.descripcion),
                                Text("Puntuación: ${comment.punto}"),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
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

class Comment {
  final int id;
  final String descripcion;
  final int punto;
  final int estacionamiento;
  final int usuario;
  String fullname;

  Comment({
    required this.id,
    required this.descripcion,
    required this.punto,
    required this.estacionamiento,
    required this.usuario,
    this.fullname = "",
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      descripcion: json['descripcion'],
      punto: json['punto'],
      estacionamiento: json['estacionamiento'],
      usuario: json['usuario'],
    );
  }

  void setFullname(String fullname) {
    this.fullname = fullname;
  }
}

class User {
  final int id;
  final String fullname;

  User({required this.id, required this.fullname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
    );
  }
}