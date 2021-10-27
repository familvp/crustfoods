import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/MainPage.dart';
import 'package:fooddeliveryapp/Pages/OTPPage.dart';
import 'package:fooddeliveryapp/Provider/ModalHudProgress.dart';
import 'package:fooddeliveryapp/Theme/Theme.dart';
import 'package:fooddeliveryapp/Widgets/DropDownMenu.dart';
import 'package:fooddeliveryapp/model/DropDownMenuModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  static String id = "SignIn";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _auth = FBAuth();

  String userName, phoneNumber;

  bool rememberMe = true;
  bool themeSwitch = true;

  final List<DropDownMenuModel> _routesNumberList = [
    DropDownMenuModel(routesNum: 'Trissur town'),
    DropDownMenuModel(routesNum: 'Guruvayoor - trpryar'),
    DropDownMenuModel(routesNum: 'Kannur - thalasseri'),
    DropDownMenuModel(routesNum: 'Thaliparambu - kaserkod'),
    DropDownMenuModel(routesNum: 'Manjeri - wandoor'),
    DropDownMenuModel(routesNum: 'Kondotty - nilambur'),
    DropDownMenuModel(routesNum: 'M.collage - Thamarasseri'),
    DropDownMenuModel(routesNum: 'Vadakara - nadapuram'),
    DropDownMenuModel(routesNum: 'Vengara - malappuram'),
    DropDownMenuModel(routesNum: 'Tirur - ponnani'),
    DropDownMenuModel(routesNum: 'Pattambi - tirurangadi'),
    DropDownMenuModel(routesNum: 'Calicut town-karaparambu'),
    DropDownMenuModel(routesNum: 'Calicut Beach - nadakkav'),
    DropDownMenuModel(routesNum: 'Perinthalmanna - mannarkad'),
    DropDownMenuModel(routesNum: 'Local roots'),
  ];
  DropDownMenuModel _dropDownMenuModel = DropDownMenuModel();
  List<DropdownMenuItem<DropDownMenuModel>> _routesNumberModelDropdownList;
  List<DropdownMenuItem<DropDownMenuModel>> _buildPersonNumModelDropdown(
      List personList) {
    List<DropdownMenuItem<DropDownMenuModel>> items = List();
    for (DropDownMenuModel routes in personList) {
      items.add(DropdownMenuItem(
        value: routes,
        child: Row(
          children: [
            Icon(
              Icons.place,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              routes.routesNum,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Montserrat",
              ),
            ),
          ],
        ),
      ));
    }
    return items;
  }

  _onChangeFavouriteAddressModelDropdown(DropDownMenuModel dropDownMenuModel) {
    setState(() {
      _dropDownMenuModel = dropDownMenuModel;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _routesNumberModelDropdownList =
        _buildPersonNumModelDropdown(_routesNumberList);
    _dropDownMenuModel = _routesNumberList[0];
  }

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
                  height: 10,
                ),
                Container(
                  height: 220,
                  width: 220,
                  child: SvgPicture.asset(signIn),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 67,
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "UserName is empty";
                          // ignore: missing_return
                        }
                      },
                      onSaved: (value) {
                        userName = value;
                      },
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        color: Color(0xff707070),
                        // color: Color(0xff544646)
                      ),
                      decoration: InputDecoration(
                        hintText: "Shop Name",
                        contentPadding: EdgeInsets.only(left: 20),
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 10),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Enter Phone Number With Code of Your Country",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff707070),
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 67,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLength: 15,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Phone Number is empty";
                            // ignore: missing_return
                          }
                        },
                        onSaved: (value) {
                          phoneNumber = value;
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          color: Color(0xff707070),
                        ),
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          contentPadding: EdgeInsets.only(left: 20),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                              gapPadding: 10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropDownMenu(
                  dropdownMenuItemList: _routesNumberModelDropdownList,
                  onChanged: _onChangeFavouriteAddressModelDropdown,
                  value: _dropDownMenuModel,
                  isEnabled: true,
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

                      final modalHud =
                          Provider.of<ModalHudProgress>(context, listen: false);
                      modalHud.changeIsLoading(true);

                      if (_globalKey.currentState.validate()) {
                        try {
                          _globalKey.currentState.save();

                          modalHud.changeIsLoading(false);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OTPPage(phoneNumber,
                                  userName, _dropDownMenuModel.routesNum)));
                        } catch (e) {
                          modalHud.changeIsLoading(false);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              e.message,
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      }
                      modalHud.changeIsLoading(false);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Let's Go",
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
              ],
            ),
          )),
        ),
      ),
    );
  }

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("rememberMe", rememberMe);
  }
}
