import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:async/async.dart';
import 'package:flutter_application_1/flex_screen.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'dialog_builders.dart';

import 'login_functions.dart' as logIn;

/// Main function.
void main() {
  runApp(const MyApp());
}

/// Example app widget.
class MyApp extends StatelessWidget {
  /// Main app widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Login',
      theme: ThemeData(
          primarySwatch:
            ColorService.createMaterialColor(const Color.fromARGB(101, 0, 0, 0)),
              scaffoldBackgroundColor: Colors.white,
          ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginScreen(),
        '/forgotPass': (BuildContext context) => const ForgotPasswordScreen(),
        // '/myTransaction': (BuildContext context) => MyTransactionScreen(), // 추가된 라우트
        '/flex': (BuildContext context) => FlexScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode currentMode = AuthMode.login;

  CancelableOperation? _operation;

  @override
  Widget build(BuildContext context) {
    return Container(
    child: AnimatedLogin(
      onLogin: (LoginData data) async =>
          _authOperation(logIn.LoginFunctions(context).onLogin(data)),
      onSignup: (SignUpData data) async =>
          _authOperation(logIn.LoginFunctions(context).onSignup(data)),

      // onForgotPassword: _onForgotPassword,
      logo: Image.asset('assets/images/loginScreen.gif'),
      signUpMode: SignUpModes.both,
      loginDesktopTheme: _desktopTheme,
      loginMobileTheme: _mobileTheme,
      loginTexts: _loginTexts,
      nameValidator: ValidatorModel(
        customValidator: (name)
            {
              return null;
            }
      ),
      emailValidator: ValidatorModel(
        customValidator: (id) {
          return null;
        }
      ),
      passwordValidator: ValidatorModel(
          //checkUpperCase: false, checkNumber: true,
          customValidator: (id) {
            return null;
          },
      ),
    )
    );
  }

  Future<String?> _authOperation(Future<String?> func) async {
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(func);
    final String? res = await _operation?.valueOrCancellation();
    if (_operation?.isCompleted == true) {
      DialogBuilder(context).showResultDialog(res ?? '$res.');
    }
    return res;
  }
  LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
        // To set the color of button text, use foreground color.
        actionButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        dialogTheme: const AnimatedDialogTheme(
          languageDialogTheme: LanguageDialogTheme(
              optionMargin: EdgeInsets.symmetric(horizontal: 80)),
        ),
        loadingButtonColor: Colors.white,
        privacyPolicyStyle: const TextStyle(fontFamily: "mainfont", color: Color(0xFF130101)),
        privacyPolicyLinkStyle: const TextStyle(fontFamily: "mainfont",
            color: Color(0xFF130101), decoration: TextDecoration.underline),
      );

  LoginViewTheme get _mobileTheme => LoginViewTheme(
        logoPadding: const EdgeInsets.all(20.0),
        logoSize: const Size(180, 180),
        welcomeTitleStyle: const TextStyle(
          fontFamily: "mainfont",
          fontSize: 40,
          color: Colors.black87
        ),
        welcomeDescriptionStyle: const TextStyle(
          fontFamily: "mainfont",
          fontSize: 25,
            color: Colors.black87
        ),
        changeActionTextStyle: const TextStyle(
          fontFamily: "mainfont",
          fontSize: 20,
            color: Colors.black87
        ),
        useEmailStyle: const TextStyle(
          fontFamily: "mainfont",
          fontSize: 18,
            color: Colors.black87
        ),
        actionButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              fontFamily: "mainfont",
              fontSize: 25,
            )
          )
        ),
        textFormStyle: const TextStyle(
          color: Colors.black87,
        ),
        showLabelTexts: false,
        backgroundColor: Colors.white,
        formFieldBackgroundColor: Colors.white,
        formWidthRatio: 60,

        animatedComponentOrder: const <AnimatedComponent>[
          AnimatedComponent(
            component: LoginComponents.logo,
            animationType: AnimationType.right,
          ),
          AnimatedComponent(component: LoginComponents.title),
          AnimatedComponent(component: LoginComponents.description),
          AnimatedComponent(component: LoginComponents.formTitle),
           AnimatedComponent(component: LoginComponents.useEmail),
           AnimatedComponent(component: LoginComponents.form),
          AnimatedComponent(component: LoginComponents.changeActionButton),
          AnimatedComponent(component: LoginComponents.actionButton),
        ],
        privacyPolicyStyle: const TextStyle(fontFamily: "mainfont", color: Colors.black87),
        privacyPolicyLinkStyle: const TextStyle(fontFamily: "mainfont",
            color: Colors.black87, decoration: TextDecoration.underline),
      );

  LoginTexts get _loginTexts => LoginTexts(
        nameHint: _username,
        login: _login,
        signUp: _signup,
        welcomeBack: "Mad-Bank",
        welcomeBackDescription: "편하게\n빠르게\n안전하게",
        welcome: "Mad-Bank",
        welcomeDescription: "편하게\n빠르게\n안전하게",
        signupEmailHint: '아이디를 입력해주세요',
        signupPasswordHint: '비밀번호를 입력해주세요',
        signUpFormTitle: '휴대전화 번호를 입력해주세요',
        loginEmailHint: '아이디를 입력해주세요',
        loginPasswordHint: '비밀번호를 입력해주세요',
        confirmPasswordHint: '비밀번호를 다시 입력해주세요',
        notHaveAnAccount: '계정이 없으신가요?',
        alreadyHaveAnAccount: '계정이 있으신가요?',
      );

  String get _username => '성함을 입력해주세요';

  String get _login => '로그인';

  String get _signup => '가입하기';

}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('FORGOT PASSWORD'),
      ),
    );
  }
}

class ColorService {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}