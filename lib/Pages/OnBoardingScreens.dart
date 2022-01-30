import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/SignInPage.dart';

import 'SignUpPage.dart';

class OnBoardingScreens extends StatefulWidget {
  static String id = "OnBoardingScreens";

  @override
  _OnBoardingScreensState createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Image.asset(
            logo,
            height: 250,
            width: 250,
          )),
          SizedBox(height: 5.0),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Crust Foods',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat",
                height: 1.3,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'we serve happiness',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 18,
                fontFamily: "Montserrat",
                height: 1.3,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, SignInPage.id, (route) => false);
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xffFFDB84),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                CupertinoIcons.right_chevron,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
