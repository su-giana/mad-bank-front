import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/first_tab.dart';
import 'package:flutter_application_1/market.dart';
import 'package:flutter_application_1/my_transaction/my_transaction_screen.dart';
import 'package:flutter_application_1/second_tab.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

String backgroundImagePath = 'assets/images/loginBackgroundImage.jpeg';
String baseUrl = "http://127.0.0.1:8080";

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<FirstPage> {

  late double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
  late double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
  late double centerWidth = 0.0;
  late double centerHeight = 0.0;
  late double poleHeight = deviceWidth*0.13;
  double imgSize = 48; // 1:1 image

  late final topPoint = (centerHeight - deviceWidth)*0.5; // img size = 48
  late final bottomPoint = topPoint + deviceWidth - poleHeight - imgSize; // img size = 48
  late final startPoint = 0.0;
  late final endPoint = startPoint + deviceWidth - imgSize; // img size = 48

  late final List<Widget> _widgetOptions = <Widget>[
    FirstTab(),
    SecondScreen(),
    Market(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          Scaffold(
            backgroundColor: Colors.white,
            // body: Padding(
            //   padding: EdgeInsets.fromLTRB(0, deviceHeight*0.07, 0, 0),
            //   child:
              body: LayoutBuilder(
                builder: (context, constraints) {
                  centerHeight = constraints.maxHeight;
                  centerWidth = constraints.maxWidth;
                  return Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _widgetOptions.elementAt(_selectedIndex),
                    ),
                  );
                },
              ),
            // ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: const Color.fromARGB(255, 0, 0, 0),
                    hoverColor: const Color.fromARGB(255, 96, 69, 69),
                    gap: 8,
                    activeColor: const Color.fromARGB(255, 0, 0, 0),
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.grey[100]!,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    tabs: const [
                      GButton(
                        icon: LineIcons.coins,
                        text: 'Bank',
                      ),
                      GButton(
                        icon: LineIcons.wallet,
                        text: 'ATM',
                      ),
                      GButton(
                        icon: LineIcons.store,
                        text: 'Market',
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),]
    );
  }
}


class ImagePlanThumbnail extends StatelessWidget {
  const ImagePlanThumbnail({Key? key, required this.image, required this.name, required this.id, required this.func,})
      : super(key: key);
  final String image;
  final String name;
  final int id;
  final Function func;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          margin: const EdgeInsets.only(bottom: 6),
          // decoration: BoxDecoration(
          //   image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
          //   borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: IconButton(
            icon: Transform.scale(
              scale: 5,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            iconSize: 30,
            onPressed: () {
              func();
            },
          ),
        ),
        Container(
            color: Colors.black87,
            // alignment: Alignment.center,
            child:
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
        const SizedBox(height: 20)
      ],
    );
  }
}