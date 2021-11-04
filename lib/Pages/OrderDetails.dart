import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/model/foodModel.dart';

class OrderDetails extends StatefulWidget {
  static String id = "OrderDetails";
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  DBFireStore dbFireStore = DBFireStore();

  @override
  Widget build(BuildContext context) {
    String documentId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: dbFireStore.loadOrderDetails(documentId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<FoodModel> foodModel = [];
                  for (var doc in snapshot.data.docs) {
                    var data = doc.data();

                    foodModel.add(FoodModel(
                      image: data["foodImage"],
                      title: data["foodTitle"],
                      price: data["foodPrice"],
                      shortname: data["foodshortname"],
                      quantity: data["foodQuantity"],
                    ));
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Foods",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: foodModel.length,
                            itemBuilder: (context, index) => Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 80,
                                              right: 20,
                                              bottom: 20),
                                          height: 130,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 50),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 140,
                                                        child: Text(
                                                          "${foodModel[index].title}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        width: 60,
                                                        child: Text(
                                                          "\₹${foodModel[index].price}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              color: Color(
                                                                  0xff0A9400),
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 7, right: 7),
                                                      child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                spreadRadius: 3,
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                    0,
                                                                    2), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${foodModel[index].quantity}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Montserrat"),
                                                            ),
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                      left: 12,
                                      top: 15,
                                      child: CachedNetworkImage(
                                        imageUrl: foodModel[index].image,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          backgroundColor: Colors.black,
                                        ),
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    Positioned(
                                      right: 36,
                                      top: 103,
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons_foodApp.clock,
                                              size: 14,
                                              color: Color(0xff707070),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                "30 Min",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: "Montserrat",
                                                  color: Color(0xff707070),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                      ),
                    ],
                  );
                } else {
                  return Center(
                      child: SpinKitRipple(
                    size: 70,
                    color: Color(0xffFFDB84),
                  ));
                }
              })),
    );
  }
}
