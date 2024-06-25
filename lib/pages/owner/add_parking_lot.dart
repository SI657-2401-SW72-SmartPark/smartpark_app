import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';

class AddParkingLot extends StatefulWidget {
  const AddParkingLot({Key? key}) : super(key: key);

  @override
  _AddParkingLotState createState() => _AddParkingLotState();
}

class _AddParkingLotState extends State<AddParkingLot> {
  late TextEditingController _nameController;
  late TextEditingController _capacityController;
  late TextEditingController _imageController;
  late int _userId;
  LatLng? _selectedLocation;
  String _selectedAddress = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _capacityController = TextEditingController();
    _imageController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('id') ?? 0;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addParkingLot() async {
    int nextId = await _getNextParkingLotId();

    String apiUrl = "https://modest-education-production.up.railway.app/api/v1/zona_aparcamiento/guardar";
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'id': nextId,
      'nombre': _nameController.text,
      'direccion': _selectedAddress,
      'numeroEstacionamiento': int.parse(_capacityController.text),
      'descripcion': _selectedLocation != null ? '${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}' : '',
      'pais': 'Perú',
      'localizacion': 'Lima, Perú',
      'imagen': _imageController.text,
      'usuario': _userId
    });

    var response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print('Failed to add parking lot. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('¡Bien hecho!'),
          content: Text('Se agregó el estacionamiento correctamente'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/parking');
              },
            ),
          ],
        ),
      );
    }
  }

  Future<int> _getNextParkingLotId() async {
    try {
      String apiUrl = "https://modest-education-production.up.railway.app/api/v1/zona_aparcamiento/todos";
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> parkingLots = jsonDecode(response.body);
        int highestId = 0;

        for (var parkingLot in parkingLots) {
          int id = parkingLot['id'];
          if (id > highestId) {
            highestId = id;
          }
        }

        return highestId + 1;
      } else {
        print('Failed to load parking lots: ${response.statusCode}');
        return 1;
      }
    } catch (e) {
      print('Error fetching parking lots: $e');
      return 1;
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _selectedAddress = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
          print('Selected Address: $_selectedAddress');
        });
      } else {
        setState(() {
          _selectedAddress = '';
          print('Selected Address: $_selectedAddress');
        });
      }
    } catch (e) {
      print('Error obteniendo dirección: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar estacionamiento'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileTextField(Icons.person, 'Nombre del estacionamiento', _nameController),
            SizedBox(height: 20),
            Text(
              'Elija la ubicación del estacionamiento en el mapa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? LatLng(-12.046374, -77.042793),
                  zoom: 15,
                ),
                markers: _selectedLocation != null
                    ? {
                  Marker(
                    markerId: MarkerId('selected-location'),
                    position: _selectedLocation!,
                  ),
                }
                    : {},
                onTap: (LatLng latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                    _getAddressFromLatLng(latLng);
                    print('Selected Location: $_selectedLocation');
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            _buildProfileTextField(Icons.car_rental, 'Capacidad', _capacityController),
            _buildProfileTextField(Icons.image, 'Imagen URL', _imageController),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addParkingLot,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF02BBD2),
                ),
                child: Text('Registrar'),
              ),
            ),
          ],
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