import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/select_account.dart';
import 'package:flutter_application_1/select_deposit_account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../first_tab.dart';
import '../no_account_form.dart';
import '../with_account_form.dart';

final defaultTextStyle = TextStyle(
  fontFamily: 'YourDesiredFont',
  fontSize: 16,
);

final String baseUrl = 'http://168.131.151.213:4040';

class MyTransactionScreen extends StatefulWidget{

  late final Account item;

  MyTransactionScreen(this.item);

  @override
  _MyTransactionScreenState createState()=> _MyTransactionScreenState();
}

class _MyTransactionScreenState extends State<MyTransactionScreen>{

  @override
  void initState() {
    super.initState();
  }

  Future<String> getUserByAccountId(int id) async{
    String? userToken = await getJwtToken();
    String url = '$baseUrl/get_username_with_id?id=${id}';

    try
        {
          Map<String, String> headers = {
            'Authorization': "Bearer $userToken"
          };

          final response = await http.get(Uri.parse(url), headers: headers);

          if(response.statusCode==200)
            {
              String body = json.decode(response.body);
              return body;
            }
          throw Exception("Not a valid user");
        }
        catch(error)
    {
      print("${error}");
      return "";
    }
  }

  Future<List<TransactionWithName>> getUserInfoList(List<Transaction> transactions) async
  {
    final List<TransactionWithName> userInfo = [];
    for(var transaction in transactions)
      {
        String senderName = await getUserByAccountId(transaction.senderId);
        String receiverName = await getUserByAccountId(transaction.receiverId);

        userInfo.add(TransactionWithName(trans: transaction, senderName: senderName, receiverName: receiverName));
      }

    return userInfo;
  }

  Future<List<TransactionWithName>> getTransactionList() async {
    String? userToken = await getJwtToken();
    String url = '$baseUrl/consume_list?account=${widget.item.id}';


    try {
      Map<String, String> headers = {
        'Authorization': "Bearer $userToken"
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseBody =json.decode(response.body);
        final List<dynamic> transData = responseBody as List<dynamic>;
        final List<Transaction> transactions = [];

        for(var trans in transData)
        {
          transactions.add(Transaction.fromJson(trans));
        }

        return getUserInfoList(transactions);
      } else {
        throw Exception("요청 실패 - 상태 코드: ${response.statusCode}");
      }
    }catch(error){
      // 요청 중 오류 발생
      print('오류 발생: $error');
    }
    return [];
  }

  FutureBuilder<List<TransactionWithName>> buildTransactionListView() {
    return FutureBuilder<List<TransactionWithName>>(
      future: getTransactionList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          List<TransactionWithName> transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              TransactionWithName transaction = transactions[index];
              return ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${transaction.trans.cost}원",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4), // Add spacing between the title and extra text
                    Text(
                      '결제 유형 : ${transaction.trans.transactionType}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 4), // Add spacing between the title and extra text
                    Text(
                      '송금 : ${transaction.senderName} | 입금 : ${transaction.receiverName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          // An error occurred while fetching data, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // Data is null or empty, you can display a message indicating no transactions
          return Text('No transactions available.');
        }
      },
    );
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
            Container(
              color: Colors.amberAccent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Row(
                        children: [
                          SizedBox(height: 100,),
                          Text(
                            '매드뱅크',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            widget.item.accountNumber.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.item.balance.toString()+'원',
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SelectDepositAccountTab(itemReceived: widget.item)),
                                );
                              },
                              child: Text(
                                '채우기',
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WithAccountForm(item: widget.item)),
                                );
                              },
                              child: Text(
                                '보내기',
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
            ),
            Expanded(
              child: buildTransactionListView(),
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction
{
  final int id;
  final int senderId;
  final int receiverId;
  final String transactionType;
  final int cost;
  final String resultCode;

  Transaction({required this.id, required this.senderId, required this.receiverId,
    required this.transactionType, required this.cost, required this.resultCode});

  factory Transaction.fromJson(Map<String,dynamic> json)
  {
      return Transaction(id: json['transactionId'],
          senderId: json['senderId'],
          receiverId: json['receiverId'],
          transactionType: json['transactionType'],
          cost: json['cost'],
          resultCode: json['resultCode']
      );
  }

}

class TransactionWithName
{
  final Transaction trans;
  final String senderName;
  final String receiverName;

  TransactionWithName({required this.trans, required this.senderName, required this.receiverName});

}
