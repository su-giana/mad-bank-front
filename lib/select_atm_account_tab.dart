import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'atm_form.dart';
import 'first_tab.dart';
import 'no_account_form.dart';


String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://127.0.0.1:80";

final defaultTextStyle = TextStyle(
  fontFamily: 'mainfont',
  fontSize: 16,
);


class SelectAtmAccountTab extends StatelessWidget {
  final String transactionType;

  const SelectAtmAccountTab({super.key, required this.transactionType});

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
                              MaterialPageRoute(builder: (context) => AtmForm(transactionType: transactionType, item: item)),
                            );
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start, // Adjust crossAxisAlignment
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 15, 15 ,0),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/banklogo.png',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.accountNumber}",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${item.balance}원",
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
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Image.asset(
                      'assets/images/detailInfo.gif',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text("계좌를 골라주세요",
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
              ),
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