import 'package:flutter/material.dart';
import 'package:smartpark_app/pages/home.dart';
import 'package:smartpark_app/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Correo electronico",
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
                    cursorColor: Colors.black,
                    controller: _password,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Contraseña",
                        prefixIcon: Icon(Icons.key)
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent),
                  ),
                  child: const Text(
                    "Iniciar Sesion",
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
