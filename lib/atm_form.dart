import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/loading_indicator.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:flutter_application_1/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'fail.dart';
import 'first_tab.dart';

String baseUrl = 'http://127.0.0.1';

class AtmForm extends StatefulWidget {
  final String transactionType;
  final Account item;

  const AtmForm({super.key, required this.transactionType, required this.item});

  @override
  _NoAccountFormState createState() => _NoAccountFormState();
}

class _NoAccountFormState extends State<AtmForm> {
  bool _showForm = true;
  TextEditingController costController = TextEditingController();

  Future<void> submitTransaction(String transactionType, Account item, String cost) async
  {
    final request  = Uri.parse("$baseUrl/my_transfer");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = {
      'transactionType': transactionType,
      'senderAccountId': item.id,
      'receiverAccountId': item.id,
      'cost': int.parse(cost)
    };

    var response = await http.post(request, headers:headers, body: json.encode(body));
    if(response.statusCode==200)
      {
        showDialog(
          context: context,
          builder: (context) => LoadingIndicator(), // Show the loading screen
          barrierDismissible: false, // Prevent user from dismissing the dialog
        );

        // Simulate a loading delay with Future.delayed
        // You can replace this with your actual loading logic
        Future.delayed(Duration(seconds: 2), () {
          // Pop the loading screen
          Navigator.of(context).pop();

          // Pop the two previous screens
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SuccessScreen(
                cost: int.parse(cost),
                receivedAcount: "${item.accountNumber}",
                sentAccount: "${item.accountNumber}",
              ),
            ),
          );
        });
      }
    else
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FailScreen(cost: int.parse(cost), receivedAccount: "${item.accountNumber}", sentAccount: "${item.accountNumber}")),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Use SingleChildScrollView to make the form scrollable
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: _showForm ? 300 : 0, // Adjust the height to fit the content
                  width: 300,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: Text(
                              "얼마나 보낼까요?",
                              style: TextStyle(fontFamily: "mainfont", fontSize: 35, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: costController,
                          decoration: InputDecoration(
                            hintText: '금액을 입력하세요',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          ),
                        ),
                        SizedBox(height: 20), // Add some spacing between the form and the button
                        ElevatedButton(
                          onPressed: () async {
                            await submitTransaction(widget.transactionType, widget.item, costController.text);

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black87, // Background color
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                            elevation: 5, // Elevation (shadow)
                          ),
                          child: Text(
                            '전송하기',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> getJwtToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}
