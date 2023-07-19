import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'first_page.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://172.10.5.135:80";

final defaultTextStyle = TextStyle(
  fontFamily: 'mainfont',
  fontSize: 16,
);


class FirstTab extends StatelessWidget {
  const FirstTab({Key? key}) : super(key: key);

  Future<List<Account>> getAccountList() async{

    final request  = Uri.parse("$baseUrl/account_list");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers:headers);
    var json = jsonDecode(response.body);
    List<Account> accounts = [];
    for(var accountJson in json)
    {
      accounts.add(Account.fromJson(accountJson));
    }
    return accounts;
  }

  Future<void> createAccount(BuildContext context) async
  {
    final request  = Uri.parse("$baseUrl/create_account");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers:headers);
    if(response.statusCode == 200)
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("계정 생성에 성공했습니다"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => FirstPage()));
                    },
                    child:  Text("OK"),
                  )
              ),
            ],
          );

        },
      );
    }
    else
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("계정 생성에 실패했습니다"),
            actions: [
              TextButton(
                onPressed: () {
                  // Dismiss the dialog
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // FutureBuilder<List<Account>> getMyAccountList(BuildContext context)
  // {
  //   final width = MediaQuery.of(context).size.width;
  //   final height = MediaQuery.of(context).size.height;
  //
  //   return FutureBuilder<List<Account>>(
  //       future: getAccountList(),
  //       builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot)
  //       {
  //         if(snapshot.hasData)
  //         {
  //           List<Account> accounts = snapshot.data!;
  //           return Scaffold(
  //             body: Center(
  //               child: Container(
  //                 // constraints: const BoxConstraints(maxWidth: 450),
  //                 child: ListView.builder(
  //                   itemCount: accounts.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final item = accounts[index];
  //                     return GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(builder: (context) => MyTransactionScreen(item)),
  //                         );
  //                       },
  //                       child: Container(
  //                         width: width*0.9,
  //                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: const Color(0xFFE0E0E0)),
  //                             borderRadius: BorderRadius.circular(8.0)),
  //                         padding: const EdgeInsets.all(10),
  //                         child: Column(
  //                           children: [
  //                             const SizedBox(height: 8),
  //                             Row(
  //                               crossAxisAlignment: CrossAxisAlignment.start, // Adjust crossAxisAlignment
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.fromLTRB(0, 0, 15 ,0),
  //                                   child: ClipOval(
  //                                     child: Image.asset(
  //                                       'assets/images/banklogo.png',
  //                                       height: width * 0.15,
  //                                       width: width * 0.15,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   child: Column(
  //                                     mainAxisAlignment: MainAxisAlignment.center,
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         "매드뱅크",
  //                                         style: Theme.of(context).textTheme.caption,
  //                                       ),
  //                                       SizedBox(height: height * 0.005),
  //                                       Text(
  //                                         "${item.accountNumber.substring(0, 6)}-${item.accountNumber.substring(6, 9)}-${item.accountNumber.substring(9)}",
  //                                         style: const TextStyle(
  //                                           // fontWeight: FontWeight.bold,
  //                                             fontSize: 16
  //                                         ),
  //                                       ),
  //                                       SizedBox(height: height * 0.005),
  //                                       Text(
  //                                         "${item.balance}원",
  //                                         style: const TextStyle(
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18
  //                                         ),
  //                                         maxLines: 2,
  //                                         overflow: TextOverflow.ellipsis,
  //                                       ),
  //
  //                                       SizedBox(height: height * 0.005),
  //                                       Text(
  //                                         "${DateTime.now()}에 갱신됨",
  //                                         style: Theme.of(context).textTheme.caption,
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //         else if (snapshot.hasError) {
  //           return Text('Error: ${snapshot.error}');
  //         } else {
  //           return const CircularProgressIndicator();
  //         }
  //       }
  //   );
  // }

  Future<String?> getUsernameWithToken() async
  {
    final request  = Uri.parse("$baseUrl/get_username_with_id");
    final jwtToken = await getJwtToken();
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers:headers);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // return ListView(
    //           children:[
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Column(
    //                 children: [
    //                   Image.asset(
    //                     'assets/images/mainpage.gif',
    //                     height: 200,
    //                     width: 200,
    //                     fit: BoxFit.cover,
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
    //                     child: Text("안녕하세요 님!",
    //                       style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 25,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
    //                     child: Text(
    //                       "나의 입출금 통장 😽",
    //                       style: TextStyle(
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     color: Colors.amberAccent,
    //                     child: Padding(
    //                       padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: Align(
    //                               alignment: Alignment.centerLeft,
    //                               child: Text(
    //                                 "새 계좌가 필요하신가요?",
    //                                 style: TextStyle(
    //                                   fontFamily: "mainfont",
    //                                   color: Colors.black87,
    //                                   fontSize: 20,
    //                                   fontWeight: FontWeight.bold,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           Container(
    //                             decoration: BoxDecoration(
    //                               color: Colors.white,
    //                               borderRadius: BorderRadius.circular(20),
    //                             ),
    //                             child: Padding(
    //                                 padding: const EdgeInsets.all(13.0),
    //                                 child: GestureDetector(
    //                                   child: Text(
    //                                     "계좌 개설하기!",
    //                                     style: TextStyle(
    //                                       fontFamily: "mainfont",
    //                                       color: Colors.black87,
    //                                       fontSize: 18,
    //                                     ),
    //                                   ),
    //                                   onTap: () async {
    //                                     await createAccount(context);
    //                                   },
    //                                 )
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   FutureBuilder<List<Account>>(
    //                       future: getAccountList(),
    //                       builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
    //                         if(snapshot.hasData) {
    //                           List<Account> accounts = snapshot.data!;
    //                           return GridView.builder(
    //                                   shrinkWrap: true,
    //                                   physics: NeverScrollableScrollPhysics(),
    //                                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                                     crossAxisCount: 1,
    //                                     childAspectRatio: 3.5,
    //                                   ),
    //                                   itemCount: accounts.length,
    //                                   itemBuilder: (BuildContext context, int index) {
    //                                     final item = accounts[index];
    //                                     return GestureDetector(
    //                                       onTap: ()  {
    //                                         Navigator.push(
    //                                           context,
    //                                           MaterialPageRoute(builder: (context) => MyTransactionScreen(item)),
    //                                         );
    //                                       },
    //                                       child: Container(
    //                                         width: width*0.9,
    //                                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
    //                                         decoration: BoxDecoration(
    //                                             border: Border.all(color: const Color(0xFFE0E0E0)),
    //                                             borderRadius: BorderRadius.circular(8.0)),
    //                                         padding: const EdgeInsets.all(10),
    //                                         child: Column(
    //                                           children: [
    //                                             const SizedBox(height: 8),
    //                                             Row(
    //                                               crossAxisAlignment: CrossAxisAlignment.start, // Adjust crossAxisAlignment
    //                                               children: [
    //                                                 Padding(
    //                                                   padding: const EdgeInsets.fromLTRB(0, 0, 15 ,0),
    //                                                   child: ClipOval(
    //                                                     child: Image.asset(
    //                                                       'assets/images/banklogo.png',
    //                                                       height: width * 0.15,
    //                                                       width: width * 0.15,
    //                                                       fit: BoxFit.cover,
    //                                                     ),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   child: Column(
    //                                                     mainAxisAlignment: MainAxisAlignment.center,
    //                                                     crossAxisAlignment: CrossAxisAlignment.start,
    //                                                     children: [
    //                                                       Text(
    //                                                         "매드뱅크",
    //                                                         style: Theme.of(context).textTheme.caption,
    //                                                       ),
    //                                                       SizedBox(height: height * 0.005),
    //                                                       Text(
    //                                                         "${item.accountNumber.substring(0, 6)}-${item.accountNumber.substring(6, 9)}-${item.accountNumber.substring(9)}",
    //                                                         style: const TextStyle(
    //                                                           // fontWeight: FontWeight.bold,
    //                                                             fontSize: 16
    //                                                         ),
    //                                                       ),
    //                                                       SizedBox(height: height * 0.005),
    //                                                       Text(
    //                                                         "${item.balance}원",
    //                                                         style: const TextStyle(
    //                                                             fontWeight: FontWeight.bold,
    //                                                             fontSize: 18
    //                                                         ),
    //                                                         maxLines: 2,
    //                                                         overflow: TextOverflow.ellipsis,
    //                                                       ),
    //
    //                                                       SizedBox(height: height * 0.005),
    //                                                       Text(
    //                                                         "${DateTime.now()}에 갱신됨",
    //                                                         style: Theme.of(context).textTheme.caption,
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ),
    //
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     );
    //                                   },
    //                                 );
    //                               }
    //                               else if (snapshot.hasError) {
    //                                 return Text('Error: ${snapshot.error}');
    //                               } else {
    //                                 return CircularProgressIndicator();
    //                               }
    //                       }
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //
    //         );
    return FutureBuilder<String?>(
        future: getUsernameWithToken(),
    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
    String? username = snapshot.data;
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasData) {
      return ListView(
                children:[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/mainpage.gif',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("안녕하세요 $username님!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, height *0.02, 0, height *0.02),
                            child: Text(
                              "나의 입출금 통장 😽",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder<List<Account>>(
                            future: getAccountList(),
                            builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                              if(snapshot.hasData) {
                                List<Account> accounts = snapshot.data!;
                                return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        //   crossAxisCount: 1,
                                        //   childAspectRatio: 2.75,
                                        // ),
                                        itemCount: accounts.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final item = accounts[index];
                                          return GestureDetector(
                                            onTap: ()  {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => MyTransactionScreen(item)),
                                              );
                                            },

                                            child: Container(
                                              width: width*0.9,
                                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/images/beforeselect.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                              ),
                                              padding: const EdgeInsets.all(10),

                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start, // Adjust crossAxisAlignment
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 0, 15 ,0),
                                                        child: ClipOval(
                                                          child: Image.asset(
                                                            'assets/images/banklogo.png',
                                                            height: width * 0.15,
                                                            width: width * 0.15,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "매드뱅크",
                                                              style: Theme.of(context).textTheme.caption,
                                                            ),
                                                            SizedBox(height: height * 0.005),
                                                            Text(
                                                              "${item.accountNumber.substring(0, 6)}-${item.accountNumber.substring(6, 9)}-${item.accountNumber.substring(9)}",
                                                              style: const TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                  fontSize: 16
                                                              ),
                                                            ),
                                                            SizedBox(height: height * 0.005),
                                                            Text(
                                                              "${item.balance}원",
                                                              style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 18
                                                              ),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),

                                                            SizedBox(height: height * 0.005),
                                                            Text(
                                                              "${DateTime.now()}에 갱신됨",
                                                              style: Theme.of(context).textTheme.caption,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                            }
                        ),
                        Container(
                          width: width*0.9,
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                              borderRadius: BorderRadius.circular(8.0),
                            color: Colors.amberAccent
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "새 계좌가 필요하신가요?",
                                      style: TextStyle(
                                        fontFamily: "mainfont",
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: GestureDetector(
                                        child: Text(
                                          "계좌 개설하기!",
                                          style: TextStyle(
                                            fontFamily: "mainfont",
                                            color: Colors.black87,
                                            fontSize: 18,
                                          ),
                                        ),
                                        onTap: () async {
                                          await createAccount(context);
                                        },
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

              );
    }else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return CircularProgressIndicator();
    }
        }
    );
  }


  Future<String?> getJwtToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }
}

class Account {
  final int id;
  final int userId;
  final String accountNumber;
  final int balance;

  Account({required this.id, required this.userId, required this.accountNumber, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['accountId'],
      userId: json['userId'],
      accountNumber: json['accountNumber'],
      balance: json['balance'],
    );
  }
}

// import 'dart:convert';
// import 'dart:core';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'first_page.dart';
//
// String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
// String baseUrl = "http://127.0.0.1:8080";
//
// final defaultTextStyle = TextStyle(
//   fontFamily: 'mainfont',
//   fontSize: 16,
// );
//
//
// class FirstTab extends StatelessWidget {
//   const FirstTab({Key? key}) : super(key: key);
//
//   Future<List<Account>> getAccountList() async{
//
//     final request  = Uri.parse("$baseUrl/account_list");
//     final jwtToken = await getJwtToken();
//     final headers = <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $jwtToken'
//     };
//
//     var response = await http.get(request, headers:headers);
//     var json = jsonDecode(response.body);
//     List<Account> accounts = [];
//     for(var accountJson in json)
//       {
//         accounts.add(Account.fromJson(accountJson));
//       }
//     return accounts;
//   }
//
//   Future<void> createAccount(BuildContext context) async
//   {
//     final request  = Uri.parse("$baseUrl/create_account");
//     final jwtToken = await getJwtToken();
//     final headers = <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $jwtToken'
//     };
//
//     var response = await http.get(request, headers:headers);
//     if(response.statusCode == 200)
//       {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               content: Text("계정 생성에 성공했습니다"),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child:GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (context) => FirstPage()));
//                     },
//                     child:  Text("OK"),
//                   )
//                 ),
//               ],
//             );
//
//           },
//         );
//       }
//     else
//       {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               content: Text("계정 생성에 실패했습니다"),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     // Dismiss the dialog
//                     Navigator.pop(context);
//                   },
//                   child: Text("OK"),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//   }
//
//   FutureBuilder<List<Account>> getMyAccountList(BuildContext context)
//   {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     return FutureBuilder<List<Account>>(
//         future: getAccountList(),
//         builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot)
//         {
//           if(snapshot.hasData)
//           {
//             List<Account> accounts = snapshot.data!;
//             return Scaffold(
//               body: Center(
//                 child: Container(
//                   // constraints: const BoxConstraints(maxWidth: 450),
//                   child: ListView.builder(
//                     itemCount: accounts.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final item = accounts[index];
//                       return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => MyTransactionScreen(item)),
//                             );
//                           },
//                           child: Container(
//                             width: width*0.9,
//                             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: const Color(0xFFE0E0E0)),
//                                 borderRadius: BorderRadius.circular(8.0)),
//                             padding: const EdgeInsets.all(10),
//                             child: Column(
//                               children: [
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start, // Adjust crossAxisAlignment
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(0, 0, 15 ,0),
//                                       child: ClipOval(
//                                         child: Image.asset(
//                                           'assets/images/banklogo.png',
//                                           height: width * 0.15,
//                                           width: width * 0.15,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "매드뱅크",
//                                             style: Theme.of(context).textTheme.caption,
//                                           ),
//                                           SizedBox(height: height * 0.005),
//                                           Text(
//                                             "${item.accountNumber.substring(0, 6)}-${item.accountNumber.substring(6, 9)}-${item.accountNumber.substring(9)}",
//                                             style: const TextStyle(
//                                                 // fontWeight: FontWeight.bold,
//                                                 fontSize: 16
//                                             ),
//                                           ),
//                                           SizedBox(height: height * 0.005),
//                                           Text(
//                                             "${item.balance}원",
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//
//                                           SizedBox(height: height * 0.005),
//                                           Text(
//                                             "${DateTime.now()}에 갱신됨",
//                                             style: Theme.of(context).textTheme.caption,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                     },
//                   ),
//                 ),
//               ),
//             );
//           }
//           else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return const CircularProgressIndicator();
//           }
//         }
//     );
//   }
//
//   Future<String?> getUsernameWithToken() async
//   {
//     final request  = Uri.parse("$baseUrl/get_username_with_id");
//     final jwtToken = await getJwtToken();
//     final headers = <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $jwtToken'
//     };
//
//     var response = await http.get(request, headers:headers);
//     return response.body;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTextStyle(
//       style: defaultTextStyle,
//       child: FutureBuilder<String?>(
//         future: getUsernameWithToken(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasData) {
//             String? username = snapshot.data;
//             return Column(
//               children: [
//                 Image.asset(
//                   'assets/images/mainpage.gif',
//                   height: 200,
//                   width: 200,
//                   fit: BoxFit.cover,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
//                   child: Text("안녕하세요 ${username}님!",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
//                   child: Text(
//                     "나의 입출금 통장 😽",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.amberAccent,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               "새 계좌가 필요하신가요?",
//                               style: TextStyle(
//                                 fontFamily: "mainfont",
//                                 color: Colors.black87,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(13.0),
//                             child: GestureDetector(
//                               child: Text(
//                                 "계좌 개설하기!",
//                                 style: TextStyle(
//                                   fontFamily: "mainfont",
//                                   color: Colors.black87,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                                 onTap: () async {
//                                   await createAccount(context);
//                                 },
//                             )
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: getMyAccountList(context),
//                 ),
//               ],
//             );
//           } else {
//             return Text('Failed to fetch username.');
//           }
//         },
//       ),
//     );
//   }
//
//
//   Future<String?> getJwtToken() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('jwtToken');
//   }
// }
//
// class Account {
//   final int id;
//   final int userId;
//   final String accountNumber;
//   final int balance;
//
//   Account({required this.id, required this.userId, required this.accountNumber, required this.balance});
//
//   factory Account.fromJson(Map<String, dynamic> json) {
//     return Account(
//       id: json['accountId'],
//       userId: json['userId'],
//       accountNumber: json['accountNumber'],
//       balance: json['balance'],
//     );
//   }
// }