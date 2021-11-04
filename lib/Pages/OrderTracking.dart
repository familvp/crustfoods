import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/AboutUs.dart';
import 'package:fooddeliveryapp/Pages/OrderDetails.dart';
import 'package:fooddeliveryapp/main.dart';
import 'package:fooddeliveryapp/model/orderModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timeago/timeago.dart' as timeago;

class OrderTracking extends StatefulWidget {
  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  final DBFireStore dbFireStore = DBFireStore();
  final FBAuth fbAuth = FBAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Your Orders",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                  ),
                ),
                Row(
                  children: <Widget>[
                    Tooltip(
                      message: "Call us",
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFDB84),
                          fontFamily: "Montserrat"),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6)),
                      child: GestureDetector(
                        onTap: () async {
                          const url =
                              "tel:0645376645"; // change your phone number here
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
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
                            child: Icon(
                              Icons_foodApp.call_us,
                              size: 21,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: dbFireStore.loadOrdersForUser(),
                builder: (context, snapshot) {
                  /*
                   i use try catch inside builder because (snapshot.data.docs.length == 0)
                   throw error message
                  */

                  if (snapshot.data.docs.length == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: 260,
                            width: 260,
                            child: SvgPicture.asset(order_empty)),
                        Text(
                          "No Order yet",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          ),
                        )
                      ],
                    );
                  } else {
                    List<OrderModel> orders = [];
                    for (var doc in snapshot.data.docs) {
                      var data = doc.data();

                      orders.add(OrderModel(
                          documentId: doc.documentID,
                          orderNumber: data["orderNumber"],
                          totalPrice: data["totalPrice"],
                          totalQuantity: data["totalQuantity"],
                          shippingPrice: data["ShippingPrice"],
                          phoneNumber: data["phoneNumber"],
                          userName: data["userName"],
                          routes: data["address"],
                          orderStatus: data["orderStatus"],
                          dateTime: data["dateTime"],
                          listFood: data["ListFood"]));
                    }
                    return ListView.builder(
                        itemCount: orders.length,
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, bottom: 100),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      " -------  ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff707070),
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    Text(
                                      "${orders[index].dateTime.toDate().toString().substring(0, 16)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff707070),
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "/",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff707070),
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${timeago.format(orders[index].dateTime.toDate())}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff707070),
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    Text(
                                      "  ------- ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff707070),
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, OrderDetails.id,
                                          arguments: orders[index].documentId);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 510,
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, right: 15, left: 15),
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 80,
                                                        width: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Total",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "Montserrat",
                                                              ),
                                                            ),
                                                            Text(
                                                              "Price",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "Montserrat",
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "\₹",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color(
                                                                        0xff0A9400),
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${orders[index].totalPrice}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Color(
                                                                        0xff0A9400),
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: 80,
                                                        width: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Total",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "Montserrat",
                                                              ),
                                                            ),
                                                            Text(
                                                              "Quantity",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "Montserrat",
                                                              ),
                                                            ),
                                                            Text(
                                                              "${orders[index].totalQuantity}",
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(
                                                                    0xff707070),
                                                                fontFamily:
                                                                    "Montserrat",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Icon(
                                                        Icons_foodApp
                                                            .order_number,
                                                        size: 18,
                                                        color:
                                                            Color(0xff544646),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    "${orders[index].orderNumber}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Icon(
                                                        Icons_foodApp
                                                            .phone_call,
                                                        size: 18,
                                                        color:
                                                            Color(0xff544646),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    "${orders[index].phoneNumber}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff707070),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Icon(
                                                        Icons_foodApp.customers,
                                                        size: 18,
                                                        color:
                                                            Color(0xff544646),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    "${orders[index].userName}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff707070),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Icon(
                                                        Icons_foodApp.address,
                                                        size: 18,
                                                        color:
                                                            Color(0xff544646),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    "${orders[index].routes}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff707070),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Icon(
                                                        orders[index]
                                                                    .orderStatus ==
                                                                "Order Received"
                                                            ? Icons_foodApp
                                                                .order
                                                            : orders[index]
                                                                        .orderStatus ==
                                                                    "Being Prepared"
                                                                ? Icons_foodApp
                                                                    .order
                                                                : orders[index]
                                                                            .orderStatus ==
                                                                        "On The Way"
                                                                    ? Icons_foodApp
                                                                        .order_ontheway
                                                                    : orders[index].orderStatus ==
                                                                            "Delivered"
                                                                        ? Icons_foodApp
                                                                            .order_success
                                                                        : Icons_foodApp
                                                                            .order,
                                                        size: 18,
                                                        color:
                                                            Color(0xff544646),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    "${orders[index].orderStatus}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff0A9400),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              " ------------------- Food List ------------------- ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff707070),
                                                fontFamily: "Montserrat",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 35,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              spreadRadius: 3,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: Icon(
                                                        Icons_foodApp.order,
                                                        size: 18,
                                                        color:
                                                            Color(0xff544646),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Container(
                                                    width: 250,
                                                    child: Text(
                                                      "${List.from(orders[index].listFood)}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff707070),
                                                        fontFamily:
                                                            "Montserrat",
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
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    ));
  }
}
