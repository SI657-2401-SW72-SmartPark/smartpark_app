import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getParkDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var products = snapshot.data as List<dynamic>;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return CardHome(
                    title: product['title'],
                    description: product['description'],
                    price: product['price'],
                    rating: product['rating'],
                    imageUrl: product['images'][0],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<dynamic>> getParkDetails() async {
    var response = await http.get(Uri.https("dummyjson.com", 'products'));
    var data = jsonDecode(response.body);
    var products = data['products'] as List<dynamic>; // Acceder a la lista de productos
    return products;
  }
}

class CardHome extends StatelessWidget {
  final String title;
  final String description;
  final int price;
  final double rating;
  final String imageUrl;

  const CardHome({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
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
            // Imagen del producto
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl), // URL de la imagen
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16), // Espacio entre la imagen y los datos

            // Detalles del producto
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
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$$price',
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
