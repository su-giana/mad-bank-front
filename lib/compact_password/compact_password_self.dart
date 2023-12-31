import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../fail.dart';
import '../first_page.dart';
import '../first_tab.dart';
import '../loading_indicator.dart';
import '../success.dart';

String baseUrl = 'http://172.10.5.135:80';

class PasswordSelfTransferScreen extends StatefulWidget {
  final String transactionType;
  final Account receivedItem;
  final int cost;

  const PasswordSelfTransferScreen({super.key, required this.transactionType, required this.receivedItem, required this.cost });

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordSelfTransferScreen> {
  final int passwordLength = 6;
  String enteredPassword = '';
  bool isPasswordComplete = false;
  double opacity = 0.0;

  Future<void> submitTransaction(String transactionType, Account item, int cost, String compactPasswod) async
  {
    final request = Uri.parse("$baseUrl/my_transfer");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var body = {
      'transactionType': transactionType,
      'senderAccountId': item.id,
      'receiverAccountNumber': item.accountNumber,
      'cost': cost,
      'compactPassword': compactPasswod
    };

    var response = await http.post(
        request, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => LoadingIndicator(), // Show the loading screen
        barrierDismissible: false, // Prevent user from dismissing the dialog
      );

      // Simulate a loading delay with Future.delayed
      // You can replace this with your actual loading logic
      Future.delayed(Duration(seconds: 2), () {
        // Pop the loading screen
        Navigator.of(context).pop();

        // Pop the two previous screens
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SuccessScreen(
                  cost: cost,
                  receivedAcount: "${item.accountNumber}",
                  sentAccount: "${item.accountNumber}",
                ),
          ),
        );
      });
    }
    else {
      showDialog(
        context: context,
        builder: (context) => LoadingIndicator(), // Show the loading screen
        barrierDismissible: false, // Prevent user from dismissing the dialog

      );

      // Simulate a loading delay with Future.delayed
      // You can replace this with your actual loading logic
      Future.delayed(Duration(seconds: 2), () {
        // Pop the loading screen
        Navigator.of(context).pop();

        // Pop the two previous screens
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                FailScreen(
                  cost: cost,
                  receivedAccountNumber: "${item.accountNumber}",
                  sentAccountNumber: "${item.accountNumber}",
                ),
          ),
        );
      });
    }
  }

    @override
  void initState() {
    // super.initState();
    // // Call a function to disable the software keyboard and focus on the TextFormField
    // disableKeyboard();
      super.initState();
      // Call a function to disable the software keyboard and focus on the TextFormField
      disableKeyboard();
      // Start the fade-in animation after a short delay
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          opacity = 0.0;
        });
      });
  }

  // Function to update the entered password and check if it's complete
  void updatePassword(String value) {
    setState(() {
      enteredPassword = value;
      isPasswordComplete = enteredPassword.length == passwordLength;
      if (isPasswordComplete) {
        opacity = 1.0;
      } else {
        opacity = 0.0;
      }
    });
  }


  // Function to handle form submission
  void onSubmit() async {
    if (isPasswordComplete) {
      await submitTransaction(widget.transactionType, widget.receivedItem , widget.cost, enteredPassword);
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
          mainAxisAlignment: MainAxisAlignment.center, // Align the Column to the top of the screen
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "간편 비밀번호를 입력해주세요",
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
            AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0), // Adjust the top padding
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
          ],
        ),
      ),
    );
  }
}



Future<String?> getJwtToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}
