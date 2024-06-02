import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartpark_app/pages/renter/home.dart';
import 'package:smartpark_app/pages/renter/parking_detail.dart';

class ReserveParking extends StatefulWidget {
  const ReserveParking({super.key});

  @override
  State<ReserveParking> createState() => _ReserveParkingState();
}

class _ReserveParkingState extends State<ReserveParking> {

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController date = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 100.0),
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Reservar Estacionamiento",
                style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 20.0
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextField(
                  controller: startTime,
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
                      prefixIcon: Icon(Icons.lock_clock)
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: TextField(
                  controller: endTime,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Hora de Finalizacion",
                      prefixIcon: Icon(Icons.punch_clock)
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: TextField(
                    controller: date,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:DateTime(2000),
                          lastDate: DateTime(2101)
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
                        hintText: "Fecha"
                    ),
                  )
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen())
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
      ),
    );
  }
}
