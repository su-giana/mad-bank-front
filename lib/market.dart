import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'first_page.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://127.0.0.1:8080";

final defaultTextStyle = TextStyle(
  fontFamily: 'mainfont',
  fontSize: 16,
);


class Market extends StatelessWidget {
  const Market({Key? key}) : super(key: key);
  Future<String?> getJwtToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  Future<List<Product>> getProductList() async {
    final request = Uri.parse("$baseUrl/market/products");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers: headers);
    var json = jsonDecode(response.body);
    List<Product> products = [];
    for (var productJson in json) {
      products.add(Product.fromJson(productJson));
    }
    return products;
  }

  FutureBuilder<List<Product>> getProductListWidget() {
    return FutureBuilder<List<Product>>(
      future: getProductList(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final item = products[index];
              return GestureDetector(
                onTap: () {
                  // Handle product selection
                  // You can navigate to a product detail page or perform any other action
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Price: ${item.price}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getProductListWidget(),
      ),
    );
  }

// Rest of the code...
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final int sellerUserId;
  final String sellerAccountNumber;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.sellerUserId,
    required this.sellerAccountNumber,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['productId'],
      name: json['productName'],
      price: json['productPrice'],
      sellerUserId: json['sellerUserId'],
      sellerAccountNumber: json['sellerAccountNumber'],
      imageUrl: json['productImg'],
    );
  }
}
// class Account {
//   final int id;
//   final int userId;
//   final int accountNumber;
//   final int balance;
//
//   Account({required this.id, required this.userId, required this.accountNumber, required this.balance});
//
//   // factory Account.fromJson(Map<String, dynamic> json) {
//   //   return Account(
//   //     id: json['accountId'],
//   //     userId: json['userId'],
//   //     accountNumber: json['accountNumber'],
//   //     // balance: json['balance'],
//   //   );
//   // }
// }