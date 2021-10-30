import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/CartPage.dart';
import 'package:fooddeliveryapp/Pages/SearchPage.dart';
import 'package:fooddeliveryapp/Pages/Home.dart';
import 'package:fooddeliveryapp/Pages/OrderTracking.dart';
import 'package:fooddeliveryapp/Provider/CartItem.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static String id = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  DBFireStore dbFireStore = DBFireStore();
  final _auth = FBAuth();
  User _loggedUser;

  // getCurrentUser() async{
  //
  //   await _auth.loadUserData();
  //   print("current user : $phoneNumber");
  // }

  // void getUserData() async {
  //   User user = FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .get()
  //       .then((userData) {
  //
  //     setState(() {
  //       phoneNumber = userData.data()['PhoneNumber'].toString();
  //       userName = userData.data()['UserName'].toString();
  //
  //     });
  //
  //       });
  //
  //   print("current phoneNumber : $phoneNumber");
  //       }

  List<Widget> _pages = <Widget>[
    Home(),
    OrderTracking(),
    CartPage(),
    SearchPage()
  ];

  @override
  Widget build(BuildContext context) {
    var cartFood = Provider.of<CartItems>(context);

    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: dbFireStore.loadOrdersForUser(),
            builder: (context, snapshot) {
              /*
                   i use try catch inside builder because (snapshot.data.docs.length == 0)
                   throw error message
                  */
              try {
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: _pages.elementAt(_selectedIndex),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, right: 15, left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: GNav(
                                curve: Curves.easeOutExpo,
                                gap: 3,
                                color: Colors.white,
                                activeColor: Colors.black,
                                iconSize: 24,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6.7),
                                duration: Duration(milliseconds: 900),
                                tabBackgroundColor: Colors.white,
                                tabs: [
                                  GButton(
                                    icon: Icons_foodApp.home,
                                    text: 'Home',
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: "Montserrat"),
                                  ),
                                  GButton(
                                    icon: Icons_foodApp.order,
                                    text: 'Order',
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: "Montserrat"),
                                    leading: _selectedIndex == 1 ||
                                            snapshot.data.docs.length == 0
                                        ? null
                                        : Badge(
                                            animationType:
                                                BadgeAnimationType.scale,
                                            animationDuration:
                                                Duration(milliseconds: 400),
                                            badgeColor: Color(0xffff124d),
                                            elevation: 0,
                                            position: BadgePosition.topEnd(
                                                top: -3, end: -2),
                                            child: Icon(
                                              Icons_foodApp.order,
                                              color: Colors.white,
                                            )),
                                  ),
                                  GButton(
                                    text: 'Cart',
                                    icon: Icons_foodApp.cart,
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: "Montserrat"),
                                    // if i clicked in icon cart disable the badge widget
                                    leading: cartFood.itemCount == 0 ||
                                            _selectedIndex == 2
                                        ? null
                                        : Badge(
                                            animationType:
                                                BadgeAnimationType.scale,
                                            animationDuration:
                                                Duration(milliseconds: 400),
                                            badgeColor: Color(0xffff124d),
                                            elevation: 0,
                                            position:
                                                BadgePosition.topEnd(top: -12),
                                            badgeContent: Text(
                                              // when add itemCount in Cart page show numberOfCount in Badge widget
                                              cartFood.itemCount.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            child: Icon(
                                              Icons_foodApp.cart,
                                              color: Colors.white,
                                            )),
                                  ),
                                  GButton(
                                    icon: Icons_foodApp.search,
                                    text: 'Search',
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: "Montserrat"),
                                  ),
                                ],
                                selectedIndex: _selectedIndex,
                                onTabChange: (index) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } catch (e) {
                return Text("");
              }
            }));
  }
}
