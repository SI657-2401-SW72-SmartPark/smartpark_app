import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartpark_app/pages/renter/home.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController birthDate = TextEditingController();

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    birthDate.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 200.0),
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                  "Ingrese sus Datos",
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
                  controller: name,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Nombre",
                      prefixIcon: Icon(Icons.person)
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
                  controller: phone,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Telefono",
                      prefixIcon: Icon(Icons.phone)
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
                  controller: address,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Direccion",
                      prefixIcon: Icon(Icons.house)
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
                    controller: birthDate,
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
                          birthDate.text = formattedDate;
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
                      prefixIcon: Icon(Icons.cake),
                      hintText: "Cumpleaños"
                  ),
                )
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent),
                ),
                child: const Text(
                  "Siguiente",
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
