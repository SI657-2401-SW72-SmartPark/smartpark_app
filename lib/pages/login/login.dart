import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpark_app/pages/shared/home.dart';
import 'package:smartpark_app/pages/login/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> _login() async {
    final response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/usuario/todos"));
    if (response.statusCode == 200) {
      List<dynamic> users = jsonDecode(response.body);
      bool isAuthenticated = false;

      for (var user in users) {
        if (user['email'] == _correo.text && user['cellphone'].toString() == _password.text) {
          isAuthenticated = true;
          _saveUserDataLocally(user); // Guarda los datos del usuario localmente
          break;
        }
      }

      if (isAuthenticated) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        _showSnackBar('Correo electrónico o contraseña incorrectos');
      }
    } else {
      _showSnackBar('Error en el servidor. Por favor, inténtelo de nuevo más tarde.');
    }
  }

  void _saveUserDataLocally(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', userData['id']);
    await prefs.setString('nombre', userData['fullname']);
    await prefs.setString('correo', userData['email']);
    await prefs.setString('telefono', userData['cellphone'].toString());
  }

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/splogo.png'),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No tienes cuenta?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage())
                        );
                      },
                      child: const Text(
                        "Crear una cuenta",
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 20.0
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: TextField(
                    controller: _correo,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Correo electrónico",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person, color: Colors.grey)
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
                    cursorColor: Colors.black,
                    controller: _password,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Contraseña",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.key, color: Colors.grey)
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent),
                  ),
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}