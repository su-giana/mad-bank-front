import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:flutter_application_1/success.dart';

import 'fail.dart';
import 'first_tab.dart';
import 'loading_indicator.dart';
import 'package:http/http.dart' as http;

String baseUrl = 'http://127.0.0.1:80';

class NoAccountForm extends StatefulWidget {
  final Account item;

  const NoAccountForm({super.key, required this.item});

  @override
  _NoAccountFormState createState() => _NoAccountFormState();
}

class _NoAccountFormState extends State<NoAccountForm> {
  bool _showForm = true;
  TextEditingController costController = TextEditingController();

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
                          onPressed: () {
                            _transfer(context, widget.item.accountNumber, int.parse(costController.text));
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

  Future<void> _transfer(BuildContext context, String accountNumber, int transferCost) async {
    final String Url = "$baseUrl/transfer_money"; //이거 주소 맞나?
    final request = Uri.parse(Url);
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var body = {
      'transactionType': 'Transfer',
      'senderAccountId': widget.item.id,
      'receiverAccountNumber': accountNumber,
      'cost': transferCost
    };

    http.Response response;
    try {
      response = await http.post(request, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
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
                cost: transferCost,
                receivedAcount: "${widget.item.accountNumber}",
                sentAccount: accountNumber,
              ),
            ),
          );
        });
      } else {
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
              builder: (context) => FailScreen(
                cost: transferCost,
                receivedAccount: "${widget.item.accountNumber}",
                sentAccount: accountNumber,
              ),
            ),
          );
        });
      }
    } catch (error) {
      print('error : $error');
    }

  }
}
