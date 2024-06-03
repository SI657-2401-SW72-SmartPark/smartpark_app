import 'package:flutter/material.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nombreController = TextEditingController(text: '');
    final TextEditingController _correoController = TextEditingController(text: 'correo@example.com');
    final TextEditingController _numeroController = TextEditingController(text: '');
    final TextEditingController _direccionController = TextEditingController(text: '');
    final TextEditingController _cumpleanosController = TextEditingController(text: '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://as2.ftcdn.net/v2/jpg/03/83/25/83/1000_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg'),
              ),
              SizedBox(height: 20),
              _buildProfileTextField('Nombre de usuario', _nombreController),
              _buildProfileTextField('Correo electrónico', _correoController),
              _buildProfileTextField('Número de teléfono', _numeroController),
              _buildProfileTextField('Dirección de domicilio', _direccionController),
              _buildProfileTextField('Fecha de cumpleaños', _cumpleanosController),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF02BBD2),
                  ),
                  child: Text('Editar perfil'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF02BBD2),
                  ),
                  child: Text('Cerrar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }

  Widget _buildProfileTextField(String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF02BBD2)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0),
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
    );
  }
}