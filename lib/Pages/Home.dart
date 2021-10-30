import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/GlobalVariable/GlobalVariable.dart';
import 'package:fooddeliveryapp/Google%20Sheet%20Api/GSheetApi.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/AboutUs.dart';
import 'package:fooddeliveryapp/Provider/CartItem.dart';
import 'package:fooddeliveryapp/Theme/Theme.dart';
import 'package:fooddeliveryapp/model/OrderSheetModel.dart';
import 'package:fooddeliveryapp/model/foodModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignInPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _dbFireStore = DBFireStore();
  final FBAuth fbAuth = FBAuth();
  List<FoodModel> _list = [];
  bool drawerCanOpen = true;

  bool themeSwitch = false;

  int quantity = 1;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    final _auth = FirebaseAuth.instance;

    final User user = _auth.currentUser;
    uid = user.uid;

    print("User UID : $uid");

    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var data = await _firestore.collection("newUser").doc(uid).get();

    return snapshot = data;
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      getUserInfo();
    });

    return DefaultTabController(
        length: 6,
        child: Scaffold(
          key: scaffoldKey,
          drawer: Container(
            width: 280,
            child: Drawer(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    Container(
                      height: 160,
                      child: DrawerHeader(
                        decoration: BoxDecoration(),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Image.asset("assets/icons/man.png"),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 160,
                                  child: Text(
                                    // snapshot.data() == null
                                    //   ? '${snapshot?.data()["UserName"]?.toString()}'
                                    //   : "User",
                                    "User",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'I\'m a Client',
                                  style: TextStyle(fontFamily: "Montserrat"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: themeSwitch
                          ? Icon(
                              Icons_foodApp.dark_mode,
                              size: 25,
                            )
                          : Icon(
                              Icons_foodApp.white_mode,
                              size: 25,
                            ),
                      title: Text(
                        'Switch Theme',
                        style:
                            TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                      ),
                      onTap: () {
                        setState(() {
                          themeSwitch = !themeSwitch;
                          themeProvider.swapTheme();
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons_foodApp.resturant,
                        size: 25,
                      ),
                      title: Text(
                        'About Us',
                        style:
                            TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, AboutUs.id);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons_foodApp.logout,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontFamily: "Montserrat"),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                  child: AlertDialog(
                                    title: Text(
                                      "Sign Out",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    content: Text(
                                      "are you sure?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Montserrat",
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text(
                                            "NO",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff707070),
                                                fontFamily: "Montserrat"),
                                          )),
                                      FlatButton(
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.clear();
                                            await fbAuth.signOut();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                SignInPage.id,
                                                (route) => false);
                                          },
                                          child: Text(
                                            "YES",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff707070),
                                                fontFamily: "Montserrat"),
                                          ))
                                    ],
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(180),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: new AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: new Column(
                  children: [
                    new Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Crust Foods",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  fontFamily: "Montserrat"
                                  // color: Color(0xff544646),
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (drawerCanOpen) {
                                  scaffoldKey.currentState.openDrawer();
                                } else {}
                              },
                              child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.menu,
                                    size: 19,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 30,
                    ),
                    new TabBar(
                      isScrollable: true,
                      indicatorWeight: 6,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 4,
                        ),
                        insets: EdgeInsets.symmetric(horizontal: 30),
                      ),
                      labelPadding: EdgeInsets.all(13),
                      tabs: <Widget>[
                        Tab(
                          child: SvgPicture.asset(
                            icon_Bun,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Tab(
                          child: SvgPicture.asset(
                            icon_PizzaBase,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Tab(
                          child: SvgPicture.asset(
                            icon_Breads,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Tab(
                          child: SvgPicture.asset(
                            icon_Rusks,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Tab(
                          child: SvgPicture.asset(
                            icon_Cookies,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Tab(
                          child: SvgPicture.asset(
                            icon_cake,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            foodView("Bun"),
            foodView("Breads"),
            foodView("PizzaBase"),
            foodView("Cookies"),
            foodView("Rusks"),
            foodView("cake"),
          ]),
        ));
  }

  Widget foodView(String nameCategory) {
    return StreamBuilder<QuerySnapshot>(
        stream: _dbFireStore.loadFoods(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FoodModel> _foodModel = [];
            for (var doc in snapshot.data.docs) {
              var data = doc.data();

              _foodModel.add(FoodModel(
                image: data["foodImage"],
                title: data["foodTitle"],
                price: data["foodPrice"],
                category: data["foodCategory"],
              ));
            }
            _list = [..._foodModel];
            _foodModel.clear();
            _foodModel = getFoodByCategory(nameCategory);
            return GridView.builder(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 100),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.50),
                itemCount: _foodModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, FoodDetails.id);
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: _foodModel[index].image,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 130,
                              child: Text(
                                _foodModel[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Color(0xff544646),
                                    fontSize: 15,
                                    fontFamily: "Montserrat"),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "\₹${_foodModel[index].price}",
                              style: TextStyle(
                                  color: Color(0xff0A9400),
                                  fontSize: 20,
                                  fontFamily: "Montserrat"),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 3,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.keyboard_arrow_left,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (quantity != 1) {
                                              quantity--;
                                            }
                                          });
                                        }),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "$quantity",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat"),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 3,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      addToCart(context, _foodModel[index]);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 130,
                                      child: Card(
                                        elevation: 3,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "add to cart",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat",
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
                child: SpinKitRipple(
              size: 70,
              color: Color(0xffFFDB84),
            ));
          }
        });
  }

  Future<void> addToCart(context, FoodModel fdModel) async {
    CartItems cartItem = Provider.of<CartItems>(context, listen: false);
    fdModel.quantity = quantity;
    bool exist = false;
    var foodInCart = cartItem.foodModel;
    for (var fdInCart in foodInCart) {
      if (fdInCart.title == fdModel.title) {
        exist = true;
      }
    }
    if (exist) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: AlertDialog(
                title: Icon(
                  Icons_foodApp.order_success,
                  size: 35,
                  color: Colors.redAccent,
                ),
                content: Text(
                  "this food is already in cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    color: Colors.redAccent,
                  ),
                ),
              ),
            );
          });
    } else {
      // save each order food to google sheet

      final id = await GSheetApi.getRowCount() + 1;

      final saveToGSheet = {
        OrderSheetModel.userName: snapshot?.data()["UserName"],
        OrderSheetModel.foodName: fdModel.title,
        OrderSheetModel.quantity: "3232",
        "ddsd": "sdds",
        OrderSheetModel.date: DateTime.now().toString(),
      };

      await GSheetApi.insert([saveToGSheet]);

      cartItem.addFood(fdModel);

      setState(() {
        quantity = 1;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: AlertDialog(
                title: Icon(
                  Icons_foodApp.order_success,
                  size: 35,
                  color: Colors.green,
                ),
                content: Text(
                  "Added To Cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    color: Color(0xff707070),
                  ),
                ),
              ),
            );
          });
    }
  }

  List<FoodModel> getFoodByCategory(String foodCategory) {
    List<FoodModel> _foodModel = [];
    try {
      for (var food in _list) {
        if (food.category == foodCategory) {
          _foodModel.add(food);
        }
      }
    } on Error catch (ex) {
      print(ex);
    }
    return _foodModel;
  }
}
