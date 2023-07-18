import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(PasswordScreen());
}

class PasswordScreen extends StatefulWidget {
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
  void onSubmit() {
    if (isPasswordComplete) {
      // You can access the 6-digit number as 'enteredPassword'
      print('Entered 6-digit number: $enteredPassword');
      // Do something with the 6-digit number here
      // For example, you can use it for authentication or any other purpose
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
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
                onFieldSubmitted: (_) {
                  onSubmit(); // Handle submission when the user taps done on the keyboard
                },
                keyboardType: TextInputType.number,
                maxLength: passwordLength,
                cursorColor: Colors.white, // Set the cursor color to white (hides the cursor)
                obscureText: true, // To hide the entered numbers with dots
              ),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
