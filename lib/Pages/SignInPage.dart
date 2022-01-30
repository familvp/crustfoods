import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/MainPage.dart';
import 'package:fooddeliveryapp/Provider/ModalHudProgress.dart';
import 'package:fooddeliveryapp/Theme/Theme.dart';
import 'package:fooddeliveryapp/Widgets/DropDownMenu.dart';
import 'package:fooddeliveryapp/model/DropDownMenuModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  static String id = "SignIn";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController(text: "+91");

  final _auth = FBAuth();

  String email_signIn, password_signIn;

  bool rememberMe = true;
  bool themeSwitch = true;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHudProgress>(context).isLoading,
        child: Form(
            key: _globalKey,
            child: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18, top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: "Theme Mode",
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFFDB84),
                              fontFamily: "Montserrat"),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6)),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                themeSwitch = !themeSwitch;
                                themeProvider.swapTheme();
                              });
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 4,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: themeSwitch
                                    ? Icon(
                                        Icons_foodApp.dark_mode,
                                        size: 20,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons_foodApp.white_mode,
                                        size: 20,
                                        color: Colors.black,
                                      )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 220,
                    width: 220,
                    child: SvgPicture.asset(signIn),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email is empty";
                          // ignore: missing_return
                        }
                      },
                      onSaved: (value) {
                        email_signIn = value;
                      },
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        color: Color(0xff707070),
                        // color: Color(0xff544646)
                      ),
                      decoration: InputDecoration(
                          hintText: "Email",
                          contentPadding: EdgeInsets.only(left: 20),
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 67,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password is empty";
                              // ignore: missing_return
                            }
                          },
                          onSaved: (value) {
                            password_signIn = value;
                          },
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                            color: Color(0xff707070),
                          ),
                          decoration: InputDecoration(
                              hintText: "Password",
                              contentPadding: EdgeInsets.only(left: 20),
                              hintStyle: TextStyle(
                                fontSize: 17,
                                fontFamily: "Montserrat",
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          activeColor: Colors.black,
                          checkColor: Colors.white,
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value;
                            });
                          }),
                      Text(
                        "Remember Me",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () async {
                        if (rememberMe == true) {
                          keepUserLoggedIn();
                        }

                        final modalHud = Provider.of<ModalHudProgress>(context,
                            listen: false);
                        modalHud.changeIsLoading(true);

                        if (_globalKey.currentState.validate()) {
                          try {
                            _globalKey.currentState.save();
                            final result = await _auth.signIn(
                                email_signIn, password_signIn);
                            modalHud.changeIsLoading(false);
                            Navigator.pushNamedAndRemoveUntil(
                                context, MainPage.id, (route) => false);
                            print(result.user.uid);
                          } catch (e) {
                            modalHud.changeIsLoading(false);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black,
                              content: Text(
                                e.message,
                                style: TextStyle(color: Color(0xffFFDB84)),
                              ),
                              duration: Duration(seconds: 5),
                            ));
                          }
                        }
                        modalHud.changeIsLoading(false);
                      },
                      child: Container(
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xffFFDB84)),
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  )
                ],
              ),
            ))),
      ),
    );
  }

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("rememberMe", rememberMe);
  }
}
