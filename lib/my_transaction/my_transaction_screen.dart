import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyTransactionScreen extends StatefulWidget{
  @override
  _MyTransactionScreenState createState()=> _MyTransactionScreenState();
}

class _MyTransactionScreenState extends State<MyTransactionScreen>{

  int userId =0;
  int accountNumber=0;
  int balance=0;
  // int

  @override
  void initState() {
    getDataFromServer();

    super.initState();
  }

  Future<void> getDataFromServer() async {
    String? userToken = await getJwtToken();
    String url = 'http://localhost:8080/account_list';

    try {
      // 요청 헤더에 토큰을 추가합니다.
      Map<String, String> headers = {
        'Authorization': userToken!,
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // 요청이 성공적으로 처리됨
        final responseBody =json.decode(response.body);
        final List<dynamic> accountData = responseBody as List<dynamic>;
        final userId = accountData[0]['user_id'] as int;
        final accountNumber = accountData[0]['account_number'] as int;
        final balance = accountData[0]['balance'] as int;

        print(userId);
        print(accountNumber);
        print(balance);

        setState(() {
          this.userId = userId;
          this.accountNumber = accountNumber;
          this.balance = balance;
        });

        print('응답: ${response.body}');
      } else {
        // 요청이 실패함
        print('요청 실패 - 상태 코드: ${response.statusCode}');
      }
    }catch(error){
      // 요청 중 오류 발생
      print('오류 발생: $error');
    }
  }

  Future<String?> getJwtToken() async { //Token 유효 검사.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
      ),
      body: Container(
        color: Colors.white, // 배경색 설정
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Row(
                      children: [
                        Text(
                          '매드뱅크',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          // '계좌번호',
                          accountNumber.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    // '3,553,935원',
                    balance.toString()+'원',
                    style: TextStyle(
                      fontSize: 35.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // 채우기 버튼 눌렀을 때 동작
                            },
                            child: Text(
                              '채우기',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEEAB73),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // 보내기 버튼 눌렀을 때 동작
                            },
                            child: Text(
                              '보내기',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF5A281),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('계좌 내역 1'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('계좌 내역 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('계좌 내역 3'),
                  ),
                  // 계좌 내역을 추가로 출력할 수 있음
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}