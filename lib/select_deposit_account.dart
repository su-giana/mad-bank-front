import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:flutter_application_1/no_account_form.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'first_tab.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://168.131.151.213:4040";

final defaultTextStyle = TextStyle(
  fontFamily: 'mainfont',
  fontSize: 16,
);


class SelectDepositAccountTab extends StatelessWidget {
  final Account itemReceived;
  const SelectDepositAccountTab({super.key, required this.itemReceived});

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
      if(Account.fromJson(accountJson).id == itemReceived.id)  continue;

      accounts.add(Account.fromJson(accountJson));
    }
    return accounts;
  }

  FutureBuilder<List<Account>> getMyAccountList(context)
  {
    final width= MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder<List<Account>>(
        future: getAccountList(),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot)
        {
          if(snapshot.hasData)
          {
            List<Account> accounts = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Container(
                  width: width*0.9,
                  // constraints: const BoxConstraints(maxWidth: 400),
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = accounts[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NoAccountForm(send: item, receive: itemReceived)),
                            );
                          },
                          child: Container(
                            height: 133,
                            margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/beforeselect.jpg'),
                                  fit: BoxFit.cover,
                                ),
                            ),
                            padding: const EdgeInsets.all(10),
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
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "매드뱅크",
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                          SizedBox(height: height * 0.005),
                                          Text(
                                            "${item.accountNumber.substring(0, 6)}-${item.accountNumber.substring(6, 9)}-${item.accountNumber.substring(9)}",
                                            style: const TextStyle(
                                              // fontWeight: FontWeight.bold,
                                                fontSize: 16
                                            ),
                                          ),
                                          SizedBox(height: height * 0.005),
                                          Text(
                                            "${item.balance}원",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          SizedBox(height: height * 0.005),
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
    final width= MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: defaultTextStyle,
      child: FutureBuilder<String?>(
        future: getUsernameWithToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            String? username = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.white, // Set the background color here
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
                    child: Image.asset(
                      'assets/images/loginScreen.gif',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "어떤 계좌에서 돈을 가져올까요?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Flexible(
                    child: getMyAccountList(context),
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