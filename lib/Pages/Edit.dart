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
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/AddFoodPage.dart';
import 'package:fooddeliveryapp/Pages/OrderTodays.dart';
import 'package:fooddeliveryapp/Theme/Theme.dart';
import 'package:fooddeliveryapp/model/AddFoodModel.dart';
import 'package:fooddeliveryapp/model/foodModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignInPage.dart';
import 'UpdateFoodPage.dart';

class Edit extends StatefulWidget {
  static String id = "EditPage";

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _dbFireStore = DBFireStore();
  final FBAuth fbAuth = FBAuth();
  List<FoodModel> _list = [];
  bool drawerCanOpen = true;

  AddFoodModel addFoodModel;

  bool themeSwitch = false;

  int quantity = 1;

  getUserData() async {
    // ignore: await_only_futures
    user = await FirebaseAuth.instance.currentUser;
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return DefaultTabController(
      length: 6,
      child: new Scaffold(
        key: scaffoldKey,
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
                    margin: EdgeInsets.only(top: 30),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Admin Panel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontFamily: "Montserrat"
                                // color: Color(0xff544646),
                                ),
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
                        width: 5,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 20),
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
                          icon_Breads,
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
          foodView("Kuboos"),
          foodView("PizzaBase"),
          foodView("Cookies"),
          foodView("Toast"),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 75),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, AddFoodPage.id);
            },
            label: const Text(
              'Add Food',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                  color: Colors.white),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
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
                id: doc.id,
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
                    EdgeInsets.only(left: 10, right: 10, bottom: 150, top: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.50),
                itemCount: _foodModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, FoodDetails.id);
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: _foodModel[index].image,
                              child: CachedNetworkImage(
                                imageUrl: _foodModel[index].image,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                                height: 100,
                                width: 100,
                              ),
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
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, UpdateFoodPage.id,
                                          arguments: _foodModel[index]);
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 140,
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 4, sigmaY: 4),
                                                child: AlertDialog(
                                                  title: Text(
                                                    "Delete Food",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "are you sure you want delete this?",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Montserrat",
                                                      color: Color(0xff707070),
                                                    ),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        },
                                                        child: Text(
                                                          "NO",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff707070),
                                                              fontFamily:
                                                                  "Montserrat"),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          _dbFireStore
                                                              .deleteFoods(
                                                                  _foodModel[
                                                                          index]
                                                                      .id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "YES",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .redAccent,
                                                              fontFamily:
                                                                  "Montserrat"),
                                                        ))
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 140,
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat",
                                                color: Colors.white),
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
