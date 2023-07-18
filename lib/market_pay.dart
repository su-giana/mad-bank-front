// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/market.dart';
//
// class PaymentScreen extends StatelessWidget {
//   final Product product;
//   final List<Account> userAccounts;
//
//   const PaymentScreen({
//     required this.product,
//     required this.userAccounts,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedAccount = ValueNotifier<Account?>(null);
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Flexible(
//               fit: FlexFit.loose,
//               child: Container(
//                 height: width*0.05,
//                 color: Colors.grey[200],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB( width*0.05, width*0.08, width*0.05, width*0.08),
//               child:Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '주문 상품',
//                         style: TextStyle(
//                           fontFamily: 'mainfont',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                           color: Colors.black,
// // Add any other desired styles here
//                         ),
//                       ),
//                       SizedBox(height: width*0.05),
//                       Row(
//                         children: [
//                           Container(
//                             width: width*0.3,
//                             height: width*0.3,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8.0),
//                               child: AspectRatio(
//                                 aspectRatio: 1, // 가로와 세로 크기가 동일한 정사각형 비율
//                                 child: Image.network(
//                                   product.imageUrl,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width*0.05),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 16.0),
//                                 Text(
//                                   product.name,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16.0,
//                                     color: Color(0xFF111b1f),
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(
//                                   '${product.price}원',
//                                   style: TextStyle(
//                                     fontSize: 20.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF05090a),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Container(
//                 height: width*0.05,
//                 color: Colors.grey[200],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB( width*0.05, width*0.08, width*0.05, width*0.08),
//               child: Container(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child:ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: userAccounts.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final account = userAccounts[index];
//                           return GestureDetector(
//                             onTap: () {
//                               selectedAccount.value = account;
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(right: 16.0),
//                               child: Column(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 30.0,
//                                     child: Text('${account.accountNumber}'),
//                                   ),
//                                   SizedBox(height: 8.0),
//                                   Text('Account: ${account.accountNumber}'),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     ValueListenableBuilder<Account?>(
//                       valueListenable: selectedAccount,
//                       builder: (context, account, _) {
//                         if (account != null) {
//                           return Card(
//                             child: Column(
//                               children: [
//                                 Text('Selected Account: ${account.accountNumber}'),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // Perform payment using the selected account
//                                     // You can navigate to a success screen or perform any other action
//                                   },
//                                   child: Text('Pay'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         } else {
//                           return SizedBox();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/market.dart';
//
// class PaymentScreen extends StatelessWidget {
//   final Product product;
//   final List<Account> userAccounts;
//
//   const PaymentScreen({
//     required this.product,
//     required this.userAccounts,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedAccount = ValueNotifier<Account?>(null);
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(0.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: width * 0.05,
//                 color: Colors.grey[200],
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     width * 0.05, width * 0.08, width * 0.05, width * 0.08),
//                 child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '주문 상품',
//                         style: TextStyle(
//                           fontFamily: 'mainfont',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                           color: Colors.black,
//                           // Add any other desired styles here
//                         ),
//                       ),
//                       SizedBox(height: width * 0.05),
//                       Row(
//                         children: [
//                           Container(
//                             width: width * 0.3,
//                             height: width * 0.3,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8.0),
//                               child: AspectRatio(
//                                 aspectRatio: 1, // 가로와 세로 크기가 동일한 정사각형 비율
//                                 child: Image.network(
//                                   product.imageUrl,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: width * 0.05),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 16.0),
//                                 Text(
//                                   product.name,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16.0,
//                                     color: Color(0xFF111b1f),
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(
//                                   '${product.price}원',
//                                   style: TextStyle(
//                                     fontSize: 20.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF05090a),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: width * 0.05,
//                 color: Colors.grey[200],
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                       0, width * 0.08, 0, width * 0.08),
//                   child: Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, width * 0.08),
//                           child: Text(
//                               '결제수단',
//                               style: TextStyle(
//                                 fontFamily: 'mainfont',
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 24,
//                                 color: Colors.black,
//                                 // Add any other desired styles here
//                               ),
//                             ),
//                         ),
//                         SizedBox(height: width * 0.05),
//                         // Expanded(
//                         //   child: ListView.builder(
//                         //     scrollDirection: Axis.horizontal,
//                         //     itemCount: userAccounts.length,
//                         //     itemBuilder: (BuildContext context, int index) {
//                         //       final account = userAccounts[index];
//                         //       return GestureDetector(
//                         //         onTap: () {
//                         //           selectedAccount.value = account;
//                         //         },
//                         //         child: Card(
//                         //           elevation: 2.0,
//                         //           shape: RoundedRectangleBorder(
//                         //             borderRadius: BorderRadius.circular(8.0),
//                         //           ),
//                         //           child: Container(
//                         //             padding: EdgeInsets.all(16.0),
//                         //             child: Column(
//                         //               children: [
//                         //                 CircleAvatar(
//                         //                   radius: 30.0,
//                         //                   child: Text('${account.accountNumber}'),
//                         //                 ),
//                         //                 SizedBox(height: 8.0),
//                         //                 Text('Account: ${account.accountNumber}'),
//                         //               ],
//                         //             ),
//                         //           ),
//                         //         ),
//                         //       );
//                         //     },
//                         //   ),
//                         // ),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: userAccounts.map((account) {
//                                 return Container(
//                                   margin: EdgeInsets.only(right: 16.0),
//                                   height: width * 0.3, // 카드의 가로 크기 조정
//                                   child: Card(
//                                     elevation: 2.0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                     child: Container(
//                                       padding: EdgeInsets.all(16.0),
//                                       child: Column(
//                                         children: [
//                                           CircleAvatar(
//                                             radius: 30.0,
//                                             child: Text('${account.accountNumber}'),
//                                           ),
//                                           SizedBox(height: 8.0),
//                                           Text('Account: ${account.accountNumber}'),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         ValueListenableBuilder<Account?>(
//                           valueListenable: selectedAccount,
//                           builder: (context, account, _) {
//                             if (account != null) {
//                               return Card(
//                                 child: Column(
//                                   children: [
//                                     Text('Selected Account: ${account.accountNumber}'),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         // Perform payment using the selected account
//                                         // You can navigate to a success screen or perform any other action
//                                       },
//                                       child: Text('Pay'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             } else {
//                               return SizedBox();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/market.dart';

class PaymentScreen extends StatelessWidget {
  final Product product;
  final List<Account> userAccounts;

  const PaymentScreen({
    required this.product,
    required this.userAccounts,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAccount = ValueNotifier<Account?>(null);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: width * 0.05,
                color: Colors.grey[200],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.05, width * 0.08, width * 0.05, width * 0.08),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '주문 상품',
                        style: TextStyle(
                          fontFamily: 'mainfont',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                          // Add any other desired styles here
                        ),
                      ),
                      SizedBox(height: width * 0.05),
                      Row(
                        children: [
                          Container(
                            width: width * 0.3,
                            height: width * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: AspectRatio(
                                aspectRatio: 1, // 가로와 세로 크기가 동일한 정사각형 비율
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16.0),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Color(0xFF111b1f),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '${product.price}원',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF05090a),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: width * 0.05,
                color: Colors.grey[200],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, width * 0.08, 0, width * 0.08),
                child: Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, width * 0.08),
                          child: Text(
                            '결제수단',
                            style: TextStyle(
                              fontFamily: 'mainfont',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                              // Add any other desired styles here
                            ),
                          ),
                        ),
                        SizedBox(height: width * 0.05),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: userAccounts.map((account) {
                              return Container(
                                margin: EdgeInsets.only(right: 16.0),
                                height: width * 0.3, // 카드의 가로 크기 조정
                                child: Card(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          child: Text('${account.accountNumber}'),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text('Account: ${account.accountNumber}'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ValueListenableBuilder<Account?>(
                          valueListenable: selectedAccount,
                          builder: (context, account, _) {
                            if (account != null) {
                              return Card(
                                child: Column(
                                  children: [
                                    Text('Selected Account: ${account.accountNumber}'),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Perform payment using the selected account
                                        // You can navigate to a success screen or perform any other action
                                      },
                                      child: Text('Pay'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform payment with the selected account
                      // You can navigate to a success screen or perform any other action
                    },
                    child: Text(
                      '${product.price}원 결제',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
