import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartpark_app/pages/parking_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> _products;
  late List<dynamic> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _getParkDetails();
  }

  Future<void> _getParkDetails() async {
    var response = await http.get(Uri.https("dummyjson.com", 'products'));
    var data = jsonDecode(response.body);
    setState(() {
      _products = data['products'] as List<dynamic>;
      _filteredProducts = List.from(_products);
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
          product['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearch(_products, _filterProducts));
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            var product = _filteredProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingDetail(id: product['id']),
                  ),
                );
              },
              child: CardHome(
                title: product['title'],
                description: product['description'],
                price: product['price'],
                rating: product['rating'],
                imageUrl: product['images'][0],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductSearch extends SearchDelegate<String> {
  final List<dynamic> products;
  final Function(String) filterProducts;

  ProductSearch(this.products, this.filterProducts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterProducts('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestions();
  }

  Widget _buildSuggestions() {
    final List<dynamic> filteredList = query.isEmpty
        ? products
        : products
        .where((product) =>
        product['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final product = filteredList[index];
        return ListTile(
          title: Text(product['title']),
          onTap: () {
            query = product['title'];
            filterProducts(query);
            close(context, query);
          },
        );
      },
    );
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