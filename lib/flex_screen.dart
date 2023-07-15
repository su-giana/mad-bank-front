import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class FlexScreen extends StatefulWidget{
  @override
  _FlexScreenState createState()=> _FlexScreenState();
}

class _FlexScreenState extends State<FlexScreen>{

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
    String url = 'http://172.19.176.1:8080/account_list';

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
      body: Container(
        color: Colors.white, // 배경색 설정
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                              '돈 복사하기🤑',
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
                              '돈 삭제하기',
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
          ],
        ),
      ),
    );
  }
}