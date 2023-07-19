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

String baseUrl = 'http://168.131.151.213:4040';

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
          url: Uri.parse('$baseUrl/login?account=$accountId&product=$productId&redirect_url=http://168.131.151.213:4040/transaction_done'),
        ),
        initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(useHybridComposition: true)),
        onLoadStop: (controller, url) async {
          if(url.toString().startsWith("http://168.131.151.213:4040/transaction_done")) {
            Uri uri = Uri.parse(url.toString());
            String? data = uri.queryParameters['transactionType'];

            if(data != 200 && data != "200")
            {
              Navigator.of(context).pop();
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FailScreen(cost: int.parse(widget.product.price), sentAccountNumber: widget.account.accountNumber, receivedAccountNumber: widget.product.name)));
            }
            else
            {
              Navigator.of(context).pop();
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SuccessScreen(cost: int.parse(widget.product.price), sentAccount: widget.account.accountNumber, receivedAcount: widget.product.name)),
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