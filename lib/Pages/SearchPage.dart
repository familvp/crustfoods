import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fooddeliveryapp/GlobalVariable/GlobalVariable.dart';
import 'package:fooddeliveryapp/Google%20Sheet%20Api/GSheetApi.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Provider/CartItem.dart';
import 'package:fooddeliveryapp/model/OrderSheetModel.dart';
import 'package:fooddeliveryapp/model/foodModel.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 67,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 3,
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      autocorrect: true,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        color: Color(0xff707070),
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "what would like to eat?",
                          hintStyle:
                              TextStyle(fontSize: 17, fontFamily: "Montserrat"),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Find Your Favorite Foods in Our Shop",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (name != "" && name != null)
                    ? FirebaseFirestore.instance
                        .collection('foods')
                        .where("searchIndex", arrayContains: name)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("foods")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<FoodModel> _foodModel = [];
                    for (var doc in snapshot.data.docs) {
                      var data = doc.data();

                      _foodModel.add(FoodModel(
                        image: data["foodImage"],
                        title: data["foodTitle"],
                        shortname: data["foodshortname"],
                        price: data["foodPrice"],
                        category: data["foodCategory"],
                      ));
                    }
                    return GridView.builder(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 100),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.50),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return GestureDetector(
                            onTap: () {},
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
                                      tag: data.data()["foodImage"],
                                      child: CachedNetworkImage(
                                        imageUrl: data.data()["foodImage"],
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
                                    Text(
                                      data.data()["foodTitle"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          fontFamily: "Montserrat"),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "\₹${data.data()["foodPrice"]}",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
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
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              addToCart(context,
                                                  _foodModel[index], index);
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 140,
                                              child: Card(
                                                elevation: 3,
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "add to cart",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            "Montserrat",
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToCart(context, FoodModel fdModel, int index) async {
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

      final saveToGSheet = {
        OrderSheetModel.userName: snapshot?.data()["UserName"],
        fdModel.title: fdModel.quantity,
        OrderSheetModel().date: DateTime.now().toString(),
      };

      await GSheetApi().insert([saveToGSheet]);

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
}
