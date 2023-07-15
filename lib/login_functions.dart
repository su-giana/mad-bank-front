import 'dart:convert';
import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/first_page.dart';
import 'detail_info.dart';
import 'dialog_builders.dart';

String baseUrl = "http://127.0.0.1:8080";


class LoginFunctions {
  const LoginFunctions(this.context);
  final BuildContext context;


  Future<String?> onLogin(LoginData loginData) async {
    var str = await _login(loginData.email, loginData.password, context);
    await Future.delayed(const Duration(seconds: 2));
    return str;
  }

  Future<String> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      return '비밀번호가 일치하지 않습니다.';
    }


    await Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => DetailPage(signupData.email, signupData.password, signupData.name)));


    await Future.delayed(const Duration(seconds: 2));
    return "회원가입을 시도했습니다";
  }

  Future<String?> onForgotPassword(String email) async {
    DialogBuilder(context).showLoadingDialog();
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/forgotPass');
    return null;
  }
}

Future<String> _login(String id, String pw, BuildContext context) async {
  final String Url = "$baseUrl/auth";
  final request = Uri.parse(Url);
  var headers = <String, String> {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  var body = {
    'id': id,
    'password': pw,
  };

  http.Response response;
  try {
    response = await http.post(request, headers: headers, body: json.encode(body));
    if(response.statusCode == 200)
    {
      storeJwtToken(response.body);
      await Future.delayed(const Duration(seconds: 2));
      await Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => FirstPage()));
      return "로그인에 성공했습니다";
    }
    else
    {
      final error = json.decode(response.body);
      print('Request failed with status: $error');
      return "이메일과 비밀번호가 일치하지 않거나, 가입하지 않은 회원입니다.";
    }
  } 
  catch(error)
    {
      print('error : $error');
      return "이메일과 비밀번호가 일치하지 않거나, 가입하지 않은 회원입니다.";
      // return "서버와 연결 시도 중 문제가 발생했습니다.";
    }
}



Future<void> storeJwtToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwtToken', token);
}

void showCustomToast(BuildContext context, String message) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.removeCurrentSnackBar();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'mainfont',
          fontSize: 22.0,
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 94, 94, 94),
    ),
  );
}
