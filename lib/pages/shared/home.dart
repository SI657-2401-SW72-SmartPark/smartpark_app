import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartpark_app/pages/renter/parking_detail.dart';
import 'package:smartpark_app/pages/shared/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  late List<dynamic> _parkinglots;
  late List<dynamic> _filteredParkinglots;
  Set<Marker> _markers = {};
  bool _showMapView = false;

  @override
  void initState() {
    super.initState();
    _parkinglots = [];
    _filteredParkinglots = [];
    _getParkDetails();
  }

  Future<void> _getParkDetails() async {
    var response = await http.get(Uri.parse("https://modest-education-production.up.railway.app/api/v1/zona_aparcamiento/todos"));
    var data = jsonDecode(response.body);
    setState(() {
      _parkinglots = data as List<dynamic>;
      _filteredParkinglots = List.from(_parkinglots);
      _addMarkers();
    });
  }

  void _filterParkinglots(String query) {
    setState(() {
      _filteredParkinglots = _parkinglots
          .where((parkinglot) => parkinglot['nombre'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addMarkers() {
    _markers.clear();
    for (var parkinglot in _parkinglots) {
      var description = parkinglot['descripcion'].split(', ');
      var lat = double.parse(description[0]);
      var lng = double.parse(description[1]);
      _markers.add(
        Marker(
          markerId: MarkerId(parkinglot['id'].toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: parkinglot['nombre'],
            snippet: parkinglot['direccion'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParkingDetail(id: parkinglot['id']),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showMapView ? 'Mapa de Aparcamientos' : 'Lista de Aparcamientos'),
        actions: [
          ToggleButtons(
            isSelected: [_showMapView, !_showMapView],
            onPressed: (int index) {
              setState(() {
                _showMapView = index == 0;
              });
            },
            children: [
              Icon(Icons.map),
              Icon(Icons.list),
            ],
          ),
        ],
      ),
      body: _showMapView ? _buildMapView() : _buildListView(),
      bottomNavigationBar: NavBar(),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(-12.100792369834554, -77.00192282713815),
        zoom: 12.0,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }

  Widget _buildListView() {
    return Center(
      child: ListView.builder(
        itemCount: _filteredParkinglots.length,
        itemBuilder: (context, index) {
          var parkinglot = _filteredParkinglots[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParkingDetail(id: parkinglot['id']),
                ),
              );
            },
            child: CardHome(
              title: parkinglot['nombre'],
              description: parkinglot['direccion'],
              location: parkinglot['localizacion'],
              price: parkinglot['numeroEstacionamiento'],
              imageUrl: parkinglot['imagen'],
            ),
          );
        },
      ),
    );
  }
}

class CardHome extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final int price;
  final String imageUrl;

  const CardHome({
    Key? key,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    location,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < (price / 10).round() ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'S/$price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}