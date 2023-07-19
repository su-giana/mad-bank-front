import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/market.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../fail.dart';
import '../first_page.dart';
import '../first_tab.dart';
import '../loading_indicator.dart';
import '../success.dart';
import 'dialog_builders.dart';

String baseUrl = 'http://127.0.0.1:8080';

class TransferMoneyScreen extends StatefulWidget {
  final Product product;
  final Account account;


  const TransferMoneyScreen({super.key, required this.product, required this.account});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<TransferMoneyScreen> {

  @override
  Widget build(BuildContext context) {
    int accountId = widget.account.id;
    int productId = widget.product.id;

    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse('$baseUrl/login?account=$accountId&product=$productId&redirect_url=http://127.0.0.1:8080/transaction_done'),
        ),
        initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(useHybridComposition: true)),
        onLoadStop: (controller, url) async {
          if(url.toString().startsWith("http://127.0.0.1:8080/transaction_done")) {
            Uri uri = Uri.parse(url.toString());
            String? data = uri.queryParameters['transaction_type'];

            if(data != 200)
            {
              DialogBuilder(context).showResultDialog('다시 시도해주세요.');
              Navigator.of(context).pop();
            }
            else
            {
              DialogBuilder(context).showResultDialog('결제가 성공했습니다');
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FirstPage()),
              );
            }

          }
        },
      ),

    );
  }
}



Future<String?> getJwtToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}