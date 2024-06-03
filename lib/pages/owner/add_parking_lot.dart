import 'package:flutter/material.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';
import 'package:smartpark_app/pages/owner/parking_lots.dart'; // Importa la pantalla ParkingLotsScreen

class AddParkingLot extends StatelessWidget {
  const AddParkingLot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _ubicationController = TextEditingController(text: '');
    final TextEditingController _emailController = TextEditingController(text: 'correo@example.com');
    final TextEditingController _phoneController = TextEditingController(text: '');
    final TextEditingController _addressController = TextEditingController(text: '');
    final TextEditingController _birthdayController = TextEditingController(text: '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar estacionamiento'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildProfileTextField(Icons.location_on, 'Ubicación', _ubicationController),
              _buildProfileTextField(Icons.attach_money, 'Precio', _emailController),
              _buildProfileTextField(Icons.phone, 'Número de teléfono', _phoneController),
              _buildProfileTextField(Icons.description, 'Descripción', _addressController),
              _buildProfileTextField(Icons.photo, 'Foto', _birthdayController),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navega de regreso a la pantalla anterior (ParkingLotsScreen)
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF02BBD2),
                  ),
                  child: Text('Registrar'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }

  Widget _buildProfileTextField(IconData icon, String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF02BBD2)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF02BBD2),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}