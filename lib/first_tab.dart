import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://127.0.0.1:80";

final defaultTextStyle = TextStyle(
  fontFamily: 'YourDesiredFont',
  fontSize: 16,
);


class FirstTab extends StatelessWidget {
  const FirstTab({Key? key}) : super(key: key);

  Future<List<Account>> getAccountList() async{
    final request  = Uri.parse("$baseUrl/account_list");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers:headers);
    var json = jsonDecode(response.body);
    List<Account> accounts = [];
    for(var accountJson in json)
      {
        accounts.add(Account.fromJson(accountJson));
      }
    return accounts;
  }

  FutureBuilder<List<Account>> getMyAccountList()
  {
    return FutureBuilder<List<Account>>(
        future: getAccountList(),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot)
        {
          if(snapshot.hasData)
          {
            List<Account> accounts = snapshot.data!;
            return Scaffold(
              body: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = accounts[index];
                      return Container(
                        height: 133,
                        margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyTransactionScreen(item)),
                            );
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start, // Adjust crossAxisAlignment
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.balance}원",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "자립예탁금",
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "계좌 번호 : ${item.accountNumber}",
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "${DateTime.now()}에 갱신됨",
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 15 ,0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/banklogo.png',
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }

  Future<String?> getUsernameWithToken() async
  {
    final request  = Uri.parse("$baseUrl/get_username_with_id");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers:headers);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: defaultTextStyle,
      child: FutureBuilder<String?>(
        future: getUsernameWithToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            String? username = snapshot.data;
            return Column(
              children: [
                Image.asset(
                  'assets/images/mainpage.gif',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Text("안녕하세요 ${username}님!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: getMyAccountList(),
                ),
              ],
            );
          } else {
            return Text('Failed to fetch username.');
          }
        },
      ),
    );
  }


  Future<String?> getJwtToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }
}

class Account {
  final int id;
  final int userId;
  final int accountNumber;
  final int balance;

  Account({required this.id, required this.userId, required this.accountNumber, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['accountId'],
      userId: json['userId'],
      accountNumber: json['accountNumber'],
      balance: json['balance'],
    );
  }
}