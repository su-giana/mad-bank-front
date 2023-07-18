import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/market_pay.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'first_page.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://127.0.0.1:80";

final defaultTextStyle = TextStyle(
  fontFamily: 'mainfont',
  fontSize: 16,
);

class Market extends StatelessWidget {
  const Market({Key? key}) : super(key: key);

  Future<String?> getJwtToken() async {
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

  Future<List<Account>> getUserAccounts() async {
    final request = Uri.parse("$baseUrl/account_list");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers: headers);
    var json = jsonDecode(response.body);
    List<Account> accounts = [];
    for (var accountJson in json) {
      accounts.add(Account.fromJson(accountJson));
    }
    return accounts;
  }

  Widget buildPaymentForm(BuildContext context, Product product, List<Account> userAccounts) {
    final selectedAccount = ValueNotifier<Account?>(null);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Price: ${product.price}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButton<Account>(
                hint: Text('Select an account'),
                value: selectedAccount.value,
                items: userAccounts.map((account) {
                  return DropdownMenuItem<Account>(
                    value: account,
                    child: Text('Account: ${account.accountNumber}'),
                  );
                }).toList(),
                onChanged: (account) {
                  selectedAccount.value = account;
                },
              ),
              SizedBox(height: 16.0),
              ValueListenableBuilder<Account?>(
                valueListenable: selectedAccount,
                builder: (context, account, _) {
                  if (account != null) {
                    return Card(
                      child: Column(
                        children: [
                          Text('Selected Account: ${account.accountNumber}'),
                          ElevatedButton(
                            onPressed: () {
                              // Perform payment using the selected account
                              // You can navigate to a success screen or perform any other action
                            },
                            child: Text('Pay'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Market'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "눈에 보이는 ATM",
                  style: TextStyle(
                    fontFamily: "mainboldfont",
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "이 페이지는 상품 목록을 보여주는 페이지입니다.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Product>>(
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
                        final product = products[index];
                        return GestureDetector(
                          onTap: () async {
                            final userAccounts = await getUserAccounts(); // Fetch user accounts
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(product: product, userAccounts: userAccounts),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'Price: ${product.price}',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
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

class Account {
  final int id;
  final int userId;
  final int accountNumber;
  final int balance;

  Account({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['accountId'],
      userId: json['userId'],
      accountNumber: json['accountNumber'],
      balance: json['balance'],
    );
  }
}
