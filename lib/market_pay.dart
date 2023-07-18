import 'package:flutter/material.dart';
import 'package:flutter_application_1/market.dart';

class PaymentScreen extends StatefulWidget {
  final Product product;
  final List<Account> userAccounts;

  const PaymentScreen({
    required this.product,
    required this.userAccounts,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final selectedAccount = ValueNotifier<Account?>(null);
  bool showThirdPartyInfo = false;

  @override
  Widget build(BuildContext context) {
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
                                  widget.product.imageUrl,
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
                                  widget.product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Color(0xFF111b1f),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '${widget.product.price}원',
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
                        ValueListenableBuilder<Account?>(
                          valueListenable: selectedAccount,
                          builder: (context, account, _) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.userAccounts.map((account) {
                                  bool isSelected = account == selectedAccount.value;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedAccount.value = account;
                                      });
                                    },
                                    child: Card(
                                      elevation: isSelected ? 5.0 : 2.0, // 선택된 카드는 그림자를 강조
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        width: width * 0.9,
                                        height: height * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          image: isSelected
                                              ? DecorationImage(
                                            image: AssetImage('assets/images/afterselect.jpg') ,
                                            fit: BoxFit.cover,
                                          )
                                              : DecorationImage(
                                            image: AssetImage('assets/images/beforeselect.jpg') ,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          // mainAxisAlignment: ,
                                          children: [
                                            // CircleAvatar(
                                            //   radius: 30.0,
                                            //   child: Text('${account.accountNumber}'),
                                            // ),
                                            // SizedBox(height: 8.0),
                                            Flexible(
                                              flex:1,
                                              child: Container(),
                                            ),
                                            Text(
                                              '${account.balance}원',
                                              style: TextStyle(
                                                fontFamily: 'mainfont',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black,
                                                // Add any other desired styles here
                                              ),
                                            ),
                                            Text(
                                                '매드뱅크계좌(${account.accountNumber.substring(account.accountNumber.length - 4)})',
                                                style: TextStyle(
                                                  fontFamily: 'mainfont',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  // Add any other desired styles here
                                                ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        // SizedBox(height: 16.0),
                      ],
                    ),
                  ),
              ),
              // Container(
              //   height: width * 0.05,
              //   color: Colors.grey[200],
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.05, width * 0.08, width * 0.05, width * 0.08),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '결제 금액',
                        style: TextStyle(
                          fontFamily: 'mainfont',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                          // Add any other desired styles here
                        ),
                      ),
                      SizedBox(height: width * 0.05),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "주문금액",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF111b1f),
                                  ),
                                ),
                                Text(
                                  '${widget.product.price}원',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF05090a),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * 0.01),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "배송비",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF111b1f),
                                  ),
                                ),
                                Text(
                                  '무료',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF05090a),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "총 결제금액",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color(0xFF111b1f),
                                  ),
                                ),
                                Text(
                                  '${widget.product.price}원',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF05090a),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: width * 0.05,
                          //   color: Colors.grey[200],
                          // ),

                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.05,
                      color: Colors.grey[200],
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showThirdPartyInfo = !showThirdPartyInfo;
                          });
                        },
                        child: Text(
                            showThirdPartyInfo ? '개인정보 제3자 제공 ▽' : '개인정보 제3자 제공 △',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF777B7E),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade200),
                        ),
                      ),
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 200),
                      firstChild: Container(),
                      secondChild: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        color: Colors.grey[200],
                        child: Container(
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '개인정보 제3자 제공',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              // Add your detailed information about third-party data sharing here
                              Text('이제 당신의 개인정보는 제 것입니다. 제 마음대로 할 수 있는 거죠. Madbank의 Mad를 보여드리도록 하겠습니다. 이거 만드느라 2일 다 썼다. 정말 웃겨서 숨을 쉴 수 없습니다. 맙소사, 이와 같은 드립은 어디서 오는 것입니까? 혹여 가보로 내려옵니까? 나의 공중제비를 멈추게 하십시오! 당신과 같은 재미있는 분들 덕분에 정말 웃겨서 숨을 쉴 수 없습니다. 당신과 같은 재미있는 분들 덕분에 인생이 굉장히 재미있습니다. 그러한 드립은 비밀히 보관하지 말고, 재빨리 내용물을 꺼내 주십시오. 세상에 이런 드립이 다 있겠습니까? 드립 학원의 연줄이 평균 이상입니까? 완전한 드립 기계가 틀림 없습니다. 두부, 흉부, - 모두 파열시키고 말았습니다. 나의 배꼽을 보상해 내십시오! 이것은 살인 드립입니다! 호흡이 곤란합니다! 제발 목숨을 살려 주십시오! 🤷 ♀️네? 다시요. 🙅 ♂️ 강조되고 반복되는 소리는 강아지를 불~안하게 한다구욧🙅 ♂️ 🤷 ♀️그럼 잘했다고 하지 말라구여? 💁 ♂️네에!! 아니요!!! (짝짝짝) 이렇게는 좋은게 아니에요⤴️~!!! 🤷 ♀️ 오...진짜?? 🤷 ♂️네에~!!!! 🐶 왈왈왈 🤷 ♀️ 허허허 이런소리 싫어해요 🤷 ♂️네에~!!!! 맞아요!! 그런소리를 하고있어요! 🐶ㅡㅡ왈왈왈 🤷 ♂️어어~~~그래그래 미키미키 💁 ♂️ 일로와 🙋 ♂️ 어이! 🙋 ♂️어잇 🙋 ♂️ 어잇 (짝짝) 🙋 ♂️ 어잇!!!! (짝짝) 🙋 ♂️ 어잇 🤸 ♀️ 미키 🤸'),
                            ],
                          ),
                        ),
                      ),
                      crossFadeState:
                      showThirdPartyInfo ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.fromLTRB(width * 0.1, width * 0.02, width * 0.1, width * 0.02),
          child: Container(
            height: height * 0.06,
            child: ElevatedButton(
              onPressed: () {
                // Perform payment with the selected account
                // You can navigate to a success screen or perform any other action
                // final selectedAccountValue = selectedAccount.value;
                // if (selectedAccountValue != null) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => TransferMoneyScreen(
                //         account: selectedAccountValue,
                //         product: product,
                //       ),
                //     ),
                //   );
                // }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              child: Text(
                '${widget.product.price}원 결제하기',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
