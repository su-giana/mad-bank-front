import 'package:flutter/material.dart';
import 'package:flutter_application_1/first_tab.dart';
import 'package:flutter_application_1/select_atm_account_tab.dart';

import 'fail.dart';
import 'my_transaction/my_transaction_screen.dart';

class WithAccountForm extends StatefulWidget {
  final Account item;

  const WithAccountForm({super.key, required this.item});

  @override
  _WithAccountFormState createState() => _WithAccountFormState();
}

class _WithAccountFormState extends State<WithAccountForm> {
  bool _showForm = true;
  final costController = TextEditingController();

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
                        controller: costController,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FailScreen(cost: int.parse(costController.text), sentAccount: widget.item.id.toString(), receivedAccount: widget.item.id.toString())),
                          );
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
}
