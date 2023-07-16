import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:flutter_application_1/success.dart';

import 'first_tab.dart';

class NoAccountForm extends StatefulWidget {
  final Account item;

  const NoAccountForm({super.key, required this.item});

  @override
  _NoAccountFormState createState() => _NoAccountFormState();
}

class _NoAccountFormState extends State<NoAccountForm> {
  bool _showForm = true;

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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SuccessScreen(item: TransactionWithName(trans: Transaction(id:1, senderId:1, receiverId:1, transactionType: 'Success', cost: 1000, resultCode:'Success'), receiverName: "asdf", senderName: "qwer"))),
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
      ),
    );
  }
}
