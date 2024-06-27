import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smartpark_app/pages/shared/home.dart';

class ReserveParking extends StatefulWidget {
  const ReserveParking({super.key});

  @override
  State<ReserveParking> createState() => _ReserveParkingState();
}

class _ReserveParkingState extends State<ReserveParking> {
  TextEditingController startTime = TextEditingController();
  TextEditingController hours = TextEditingController();
  TextEditingController date = TextEditingController();

  @override
  void initState() {
    super.initState();
    date.text = "";
  }

  // Función para enviar la solicitud POST
  Future<void> _reserveParking() async {
    final String apiUrl = "https://modest-education-production.up.railway.app/api/v1/reserva/guardar/0";

    DateTime? startDate;
    try {
      startDate = DateFormat('dd-MM-yyyy HH:mm').parse('${date.text} ${startTime.text}');
    } catch (e) {
      print("Error parsing date/time: $e");
      return;
    }

    Map<String, dynamic> data = {
      "id": 1,
      "inicioReserva": startDate.toIso8601String(),
      "horas": int.tryParse(hours.text) ?? 0,
      "vehiculo": 1
    };

    // Enviar la solicitud POST
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Reserva exitosa");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        print("Error: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      print("Error enviando la solicitud POST: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar estacionamiento'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100.0), // Para ajustar el margen superior
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: startTime,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      final now = DateTime.now();
                      final formattedTime = DateFormat('HH:mm').format(
                        DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
                      );
                      setState(() {
                        startTime.text = formattedTime;
                      });
                    }
                  },
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Hora de Inicio",
                    prefixIcon: Icon(Icons.lock_clock),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: hours,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Horas",
                    prefixIcon: Icon(Icons.timer),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: date,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
                      setState(() {
                        date.text = formattedDate;
                      });
                    } else {
                      print("Not Selected");
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    prefixIcon: Icon(Icons.calendar_month),
                    hintText: "Fecha",
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _reserveParking();
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
      ),
    );
  }
}