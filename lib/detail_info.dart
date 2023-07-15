import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;

String baseUrl = 'http://localhost:8080';

class DetailPage extends StatefulWidget {
  late final String id;
  late final String password;
  late final String name;

  DetailPage(this.id, this.password, this.name);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _phoneController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startAnimation(
      BuildContext context, String phone, String dob, String socialId) async {
    await _signup(
        context, widget.id, widget.password, widget.name, phone, dob, socialId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Form(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/detailInfo.gif', // Replace with your logo image path
                      width: 400, // Adjust the width as needed
                      height: 400, // Adjust the height as needed
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0.0,
                              100 * (1.0 - _animation.value),
                            ),
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: '휴대전화 번호',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0.0,
                              100 * (1.0 - _animation.value),
                            ),
                            child: TextFormField(
                              controller: _birthdateController,
                              decoration: InputDecoration(
                                labelText: '생년 월일 (YYMMDD)',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0.0,
                              100 * (1.0 - _animation.value),
                            ),
                            child: TextFormField(
                              controller: _idController,
                              decoration: InputDecoration(
                                labelText: '주민번호 뒷자리',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _startAnimation(
                          context,
                          _phoneController.text,
                          _birthdateController.text,
                          _idController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Set the background color of the button
                        onPrimary: Colors.white, // Set the text color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set the border radius
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Set padding
                        textStyle: TextStyle(
                          fontSize: 20.0, // Set the font size of the button text
                        ),
                      ),
                      child: Text('최종 제출'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<String> _signup(BuildContext context, String id, String pw,
    String username, String phone, String dob, String socialId) async {
  final String Url = "$baseUrl/signup";
  final request = Uri.parse(Url);
  var headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  var body = {
    'signUpId': id,
    'password': pw,
    'name': username,
    'phone': phone,
    'dob': dob,
    'nationalId': socialId
  };

  http.Response response;
  try {
    response = await http.post(request, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 2));
      print('Signup completed!');
      return "회원가입을 완료했습니다.";
    } else {
      print('Signup failed with status');
      // return "서버와 연결 시도 중 문제가 발생했습니다.";
      return "서버 문제일지도?";
    }
  } catch (error) {
    print('error : $error');
    return "서버와 연결 시도 중 문제가 발생했습니다.";
  }
}

void main() {
  runApp(MaterialApp(
    home: DetailPage('userId', 'password123', 'John Doe'),
  ));
}
