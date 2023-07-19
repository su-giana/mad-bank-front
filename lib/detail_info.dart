import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:flutter_application_1/compact_password/compact_password_set.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_login/flutter_login.dart';



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
    await Navigator.push(context, MaterialPageRoute(
            builder: (context) => PasswordScreen(phone, dob, socialId, widget.id, widget.password, widget.name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Form(
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
                        child: Text('등록하기'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


