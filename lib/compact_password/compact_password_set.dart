import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../first_page.dart';

String baseUrl = 'http://172.10.5.135:80';

class PasswordScreen extends StatefulWidget {
  final String phone;
  final String dob;
  final String socialId;
  final String id;
  final String password;
  final String name;

  PasswordScreen(this.phone, this.dob, this.socialId, this.id, this.password, this.name);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final int passwordLength = 6;
  String enteredPassword = '';
  bool isPasswordComplete = false;

  @override
  void initState() {
    super.initState();
    // Call a function to disable the software keyboard and focus on the TextFormField
    disableKeyboard();
  }

  // Function to update the entered password and check if it's complete
  void updatePassword(String value) {
    setState(() {
      enteredPassword = value;
      isPasswordComplete = enteredPassword.length == passwordLength;
    });
  }

  // Function to handle form submission
  void onSubmit() async {
    if (isPasswordComplete) {
      await _signup(context, widget.id, widget.password, widget.name, widget.phone, widget.dob, widget.socialId, enteredPassword);
      print('Entered 6-digit number: $enteredPassword');
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
    }
  }

  // Function to disable the software keyboard and always keep the focus on the TextFormField
  void disableKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(textFieldFocusNode);
    });
  }

  // Create a FocusNode to control the focus on the TextFormField
  final FocusNode textFieldFocusNode = FocusNode();

  // Function to handle tapping outside the form
  void handleTapOutside() {
    // Request focus on the TextFormField whenever tapped outside the form
    FocusScope.of(context).requestFocus(textFieldFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      body: GestureDetector(
        onTap: handleTapOutside, // Handle taps outside the form
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align the Column to the top of the screen
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0), // Adjust the top padding
              child: Visibility(
                visible: isPasswordComplete,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Make the button background transparent
                      shadowColor: Colors.transparent, // Remove shadow
                      elevation: 0, // Remove elevation
                    ),
                    child: Text(
                      "비밀번호 제출하기",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "비밀번호를 입력해주세요",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "mainfont",
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                passwordLength,
                    (index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundColor: index < enteredPassword.length
                        ? Colors.yellow
                        : Colors.grey,
                    radius: 20,
                    child: Text(
                      index < enteredPassword.length ? '' : '',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: TextFormField(
                focusNode: textFieldFocusNode, // Set the focusNode for the TextFormField
                decoration: InputDecoration(
                  hintText: '',
                  filled: true,
                  fillColor: Colors.transparent, // Set the background color to transparent
                  border: InputBorder.none, // Remove the bottom line
                  counterText: '',
                ),
                style: TextStyle(
                  color: Colors.white, // Set the text color to white (hides the input text)
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty && value.length <= passwordLength) {
                      updatePassword(value);
                    } else {
                      // Clear the enteredPassword when the value is empty
                      enteredPassword = '';
                    }
                  });
                },
                onFieldSubmitted: (_) {},
                keyboardType: TextInputType.number,
                maxLength: passwordLength,
                cursorColor: Colors.white, // Set the cursor color to white (hides the cursor)
                obscureText: true, // To hide the entered numbers with dots
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _signup(BuildContext context, String id, String pw, String username, String phone, String dob, String socialId, String compactPassword) async {
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
      'nationalId': socialId,
      'compactPassword': compactPassword
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
}
