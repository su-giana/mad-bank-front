import 'package:flutter/material.dart';
import 'package:flutter_application_1/first_tab.dart';
import 'package:flutter_application_1/select_atm_account_tab.dart';
import 'package:flutter_application_1/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'fail.dart';
import 'loading_indicator.dart';
import 'my_transaction/my_transaction_screen.dart';
import 'package:http/http.dart' as http;


String baseUrl = 'http://127.0.0.1:80';


class WithAccountForm extends StatefulWidget {
  final Account item;

  const WithAccountForm({super.key, required this.item});

  @override
  _WithAccountFormState createState() => _WithAccountFormState();
}



class _WithAccountFormState extends State<WithAccountForm> {
  bool _showForm = true;

  final _accountNumberController = TextEditingController();
  final _transferCostController = TextEditingController();

  Future<void> _startAnimation(BuildContext context, String accountNumber, int transferCost) async {
    await _transfer(context, accountNumber, transferCost);
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => FailScreen(item: TransactionWithName(trans: Transaction(id:1, senderId:1, receiverId:1, transactionType: 'Success', cost: 1000, resultCode:'Success'), receiverName: "asdf", senderName: "qwer"))),
    // );
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FailScreen(
          cost:transferCost,
          sentAccountNumber:widget.item.id.toString(), //큰일났어 비상사태...
          receivedAccountNumber:accountNumber
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                // Remove the fixed height and width to adjust the size based on content
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "어디로?",
                            style: TextStyle(fontFamily: "mainfont", fontSize: 30),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _accountNumberController,
                        decoration: InputDecoration(
                          hintText: '계좌번호를 입력하세요',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Colors.black87),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "얼마나 보낼까요?",
                            style: TextStyle(fontFamily: "mainfont", fontSize: 30),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _transferCostController,
                        decoration: InputDecoration(
                          hintText: '금액을 입력하세요',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(width: 1, color: Colors.black87),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20), // Add some spacing between the form and the button
                      ElevatedButton(
                        onPressed: () async {
                          await _startAnimation(context, _accountNumberController.text, int.parse(_transferCostController.text));
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
                receivedAccountNumber: "${widget.item.accountNumber}",
                sentAccountNumber: accountNumber,
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




  Future<String?> getJwtToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }
