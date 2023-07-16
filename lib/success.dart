import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';

class SuccessScreen extends StatelessWidget {
  final TransactionWithName item;

  const SuccessScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Icon(
            Icons.check,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '결제가 완료되었습니다',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          '송금자 : ${item.senderName} | 입금자 : ${item.receiverName}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          '결제 금액 : ${item.trans.cost}',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
