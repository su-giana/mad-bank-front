import 'package:flutter/material.dart';
import 'package:flutter_application_1/no_account_form.dart';
import 'package:flutter_application_1/select_account.dart';
import 'package:flutter_application_1/select_atm_account_tab.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFirstImage = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showFirstImage = !_showFirstImage;
          _controller.reverse();
        });
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("눈에 보이는 ATM"
                  , style: TextStyle(fontFamily: "mainboldfont", fontSize: 40, fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectAtmAccountTab(transactionType: "Deposit")),
                );
              }, // Set the onTap callback function here
              child: Image.asset(
                'assets/images/copymoney.gif', // Replace with your image path
                height: 200,
                width: 200,
              ),
            ),
            Text("돈 복사 버튼 (입금하기)"
            , style: TextStyle(fontFamily: "mainfont", fontSize: 20),),
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectAtmAccountTab(transactionType: "Withdrawal")),
                );
              }, // Set the onTap callback function here
              child: Image.asset(
                'assets/images/delmoney.gif', // Replace with your image path
                height: 200,
                width: 200,
              ),
            ),
            Text("돈 삭제 버튼 (출금하기)", style: TextStyle(fontFamily: "mainfont", fontSize: 20))
          ],
        ),
      ),
    );
  }
}

