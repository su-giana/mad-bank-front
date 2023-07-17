import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';

class SuccessScreen extends StatelessWidget {
  final int cost;
  final String sentAccount;
  final String receivedAcount;

  const SuccessScreen({Key? key, required this.cost, required this.sentAccount, required this.receivedAcount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                  size: 125,
                ),
              ),
              SizedBox(height: 30),
              Text(
                '결제가 성공하였습니다',
                style: TextStyle(fontFamily: "mainfont", fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                '송금자: ${sentAccount}',
                style: TextStyle(fontFamily: "mainfont", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                '입금자: ${receivedAcount}',
                style: TextStyle(fontFamily: "mainfont", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                '결제 금액: ${cost}',
                style: TextStyle(fontFamily: "mainfont", fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
