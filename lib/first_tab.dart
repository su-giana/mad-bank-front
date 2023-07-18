import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'first_page.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://127.0.0.1:8080";

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

  FutureBuilder<List<Account>> getMyAccountList(BuildContext context)
  {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder<List<Account>>(
        future: getAccountList(),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot)
        {
          if(snapshot.hasData)
          {
            List<Account> accounts = snapshot.data!;
            return Scaffold(
              body: Center(
                child: Container(

                  // constraints: const BoxConstraints(maxWidth: 450),
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = accounts[index];
                      return Container(
                        // height: 133,
                        // height: height * 0.2,
                        width: width*0.9,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(8.0)),
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyTransactionScreen(item)),
                            );
                          },
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
                  ),
                ),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }

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
    return DefaultTextStyle(
      style: defaultTextStyle,
      child: FutureBuilder<String?>(
        future: getUsernameWithToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            String? username = snapshot.data;
            return Column(
              children: [
                Image.asset(
                  'assets/images/mainpage.gif',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text("안녕하세요 ${username}님!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  color: Colors.amberAccent,
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

                Expanded(
                  child: getMyAccountList(context),
                ),
              ],
            );
          } else {
            return Text('Failed to fetch username.');
          }
        },
      ),
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
// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:http/http.dart' as http;
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:tuple/tuple.dart';
// import 'package:intl/intl.dart';
//
// String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
// String baseUrl = "http://10.0.2.2:8080";
//
// class NewsFeedPage2 extends StatelessWidget {
//   const NewsFeedPage2({Key? key}) : super(key: key);
//
//   Future<List<Account>> getAccountList() async{
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
//   FutureBuilder<List<Account>> getMyAccountList()
//   {
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
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: ListView.builder(
//                     itemCount: accounts.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final item = accounts[index];
//                       return Container(
//                         height: 136,
//                         margin:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//                         decoration: BoxDecoration(
//                             border: Border.all(color: const Color(0xFFE0E0E0)),
//                             borderRadius: BorderRadius.circular(8.0)),
//                         padding: const EdgeInsets.all(8),
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "${item.balance}원",
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Text("자립예탁금",
//                                         style: Theme.of(context).textTheme.caption),
//                                     const SizedBox(height: 8),
//                                     Text("${item.accountNumber} · ${DateTime.now()}에 갱신됨",
//                                         style: Theme.of(context).textTheme.caption),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icons.bookmark_border_rounded,
//                                         Icons.share,
//                                         Icons.more_vert
//                                       ].map((e) {
//                                         return InkWell(
//                                           onTap: () {},
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(right: 8.0),
//                                             child: Icon(e, size: 16),
//                                           ),
//                                         );
//                                       }).toList(),
//                                     )
//                                   ],
//                                 )),
//                           ],
//                         ),
//                       );
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
//   @override
//   Widget build(BuildContext context) {
//   }
//
//   Future<String?> getJwtToken() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('jwtToken');
//   }
// }
//
// class Article {
//   final String title;
//   final String imageUrl;
//   final String author;
//   final String postedOn;
//
//   Article(
//       {required this.title,
//         required this.imageUrl,
//         required this.author,
//         required this.postedOn});
// }
//
// final List<Article> _articles = [
//   Article(
//     title: "Instagram quietly limits ‘daily time limit’ option",
//     author: "MacRumors",
//     imageUrl: "https://picsum.photos/id/1000/960/540",
//     postedOn: "Yesterday",
//   ),
//   Article(
//       title: "Google Search dark theme goes fully black for some on the web",
//       imageUrl: "https://picsum.photos/id/1010/960/540",
//       author: "9to5Google",
//       postedOn: "4 hours ago"),
//   Article(
//     title: "Check your iPhone now: warning signs someone is spying on you",
//     author: "New York Times",
//     imageUrl: "https://picsum.photos/id/1001/960/540",
//     postedOn: "2 days ago",
//   ),
//   Article(
//     title:
//     "Amazon’s incredibly popular Lost Ark MMO is ‘at capacity’ in central Europe",
//     author: "MacRumors",
//     imageUrl: "https://picsum.photos/id/1002/960/540",
//     postedOn: "22 hours ago",
//   ),
//   Article(
//     title:
//     "Panasonic's 25-megapixel GH6 is the highest resolution Micro Four Thirds camera yet",
//     author: "Polygon",
//     imageUrl: "https://picsum.photos/id/1020/960/540",
//     postedOn: "2 hours ago",
//   ),
//   Article(
//     title: "Samsung Galaxy S22 Ultra charges strangely slowly",
//     author: "TechRadar",
//     imageUrl: "https://picsum.photos/id/1021/960/540",
//     postedOn: "10 days ago",
//   ),
//   Article(
//     title: "Snapchat unveils real-time location sharing",
//     author: "Fox Business",
//     imageUrl: "https://picsum.photos/id/1060/960/540",
//     postedOn: "10 hours ago",
//   ),
// ];
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
//       id: json['id'],
//       userId: json['userId'],
//       accountNumber: json['accountNumber'],
//       balance: json['balance'],
//     );
//   }
// }
