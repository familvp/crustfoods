import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/GlobalVariable/GlobalVariable.dart';
import 'package:fooddeliveryapp/Google%20Sheet%20Api/GSheetApi.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/MainPage.dart';
import 'package:fooddeliveryapp/Pages/UserEdit.dart';
import 'package:fooddeliveryapp/Provider/CartItem.dart';
import 'package:fooddeliveryapp/Provider/ModalHudProgress.dart';
import 'package:fooddeliveryapp/Theme/Theme.dart';
import 'package:fooddeliveryapp/Widgets/DropDownMenu.dart';
import 'package:fooddeliveryapp/model/AddShopeNameModel.dart';
import 'package:fooddeliveryapp/model/DropDownMenuModel.dart';
import 'package:fooddeliveryapp/model/OrderSheetModel.dart';
import 'package:fooddeliveryapp/model/foodModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../model/foodModel.dart';

class CartPage extends StatefulWidget {
  static String id = "cartPage";

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DBFireStore dbFireStore = DBFireStore();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  FocusNode focusNode = FocusNode();
  String name = "";

  String userName, routes;
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
    getUserInfo();
    _routesNumberModelDropdownList =
        _buildPersonNumModelDropdown(_routesNumberList);
    _dropDownMenuModel = _routesNumberList[0];
    super.initState();
  }

  // Group Value for Radio Button.
  int id = 1;

  DocumentSnapshot snapshot1;

  getUserInfo() async {
    final _auth = FirebaseAuth.instance;

    final User user = _auth.currentUser;
    final uid = user.uid;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var data = await _firestore.collection("admin").doc(uid).get();

    snapshot1 = data;
  }

  // get total of All foods in cart
  Decimal getTotalPrice(List<FoodModel> foodModel) {
    var price = Decimal.fromInt(0);
    for (var food in foodModel) {
      price += ((Decimal.parse(double.parse(food.price).toString()) *
              Decimal.parse(food.quantity.toString())) +
          Decimal.parse(getShippingPrice(foodModel).toString()));
    }

    return price;
  }

  // get total of all quantity foods
  int getTotalQuantity(List<FoodModel> foodModel) {
    var allQuantity = 0;

    for (var quantity in foodModel) {
      allQuantity += quantity.quantity;
    }
    return allQuantity;
  }

  // delivery price with number of quantity
  int getShippingPrice(List<FoodModel> foodModel) {
    var shpp = 0;
    var price = 0;

    for (var shippingPrice in foodModel) {
      shpp = shippingPrice.quantity;

      if (shpp <= 5) {
        return price + 1;
      } else if (shpp >= 5 && shpp <= 10) {
        return price + 2;
      } else if (shpp >= 10 && shpp <= 15) {
        return price + 3;
      } else if (shpp >= 15) {
        return price + 5;
      }
    }

    return price;
  }

  Future placeOrder(List<FoodModel> foodModel) async {
    List<String> orderListFood = [];

    for (var foods in foodModel) {
      orderListFood.addAll([
        foods.title,
        foods.quantity.toString(),
      ]);
    }

    final Map<String, dynamic> saveToGSheet = {
      OrderSheetModel.userName: snapshot1?.data()["UserName"],
      // OrderSheetModel.qtyposition: (index + 1).toString(),
    };

    for (var i = 0; i < foodModel.length; i++) {
      saveToGSheet[foodModel[i].shortname.toString()] = foodModel[i].quantity;
    }
    print(saveToGSheet);

    await GSheetApi().insert([saveToGSheet]);

    // save Orders For Current User
    dbFireStore.saveOrderForUser(
      {
        "totalPrice": getTotalPrice(foodModel).toDouble(),
        "totalQuantity": getTotalQuantity(foodModel),
        "ShippingPrice": getShippingPrice(foodModel),
        "address": snapshot1.data()["Routes"],
        "userName": snapshot1.data()["UserName"],
        "phoneNumber": snapshot1.data()["PhoneNumber"],
        "orderNumber": randomNumeric(9),
        "orderStatus": "Order Received",
        "dateTime": DateTime.now(),
        "ListFood": orderListFood
      },
    );

    //save orders to crust food admin app
    try {
      await dbFireStore.saveOrderForAdmin(
        {
          "totalPrice": getTotalPrice(foodModel).toDouble(),
          "totalQuantity": getTotalQuantity(foodModel),
          "ShippingPrice": getShippingPrice(foodModel),
          "address": snapshot1.data()["Routes"],
          "userName": snapshot1.data()["UserName"],
          "phoneNumber": snapshot1.data()["PhoneNumber"],
          "orderNumber": randomNumeric(9),
          "orderStatus": "Order Received",
          "dateTime": DateTime.now(),
          "ListFood": orderListFood
        },
      );
    } catch (e) {
      print(e.toString());
    }

    // clear all foods in cartPage
    Provider.of<CartItems>(context, listen: false).deleteAllFoods();
    // show Dialog Success Order has been placed
  }

  @override
  Widget build(BuildContext context) {
    List<FoodModel> cartFood = Provider.of<CartItems>(context).foodModel;

    return Padding(
      padding:  MediaQuery.of(context).viewInsets,
      child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Your Cart of Foods",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"
                            // color: Color(0xff544646)
                            ),
                      ),
                      Row(
                        children: <Widget>[
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
                                            "Delete",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                          content: Text(
                                            "Do you want delete All foods?",
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
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Text(
                                                  "NO",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff707070),
                                                      fontFamily: "Montserrat"),
                                                )),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                  Provider.of<CartItems>(context,
                                                          listen: false)
                                                      .deleteAllFoods();
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
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
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
                              child: Icon(
                                Icons_foodApp.delete,
                                size: 20,
                                color: Color(0xff544646),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: cartFood.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 260,
                                width: 260,
                                child: SvgPicture.asset(cart_empty)),
                            Text(
                              "No foods yet",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat"
                                  // color: Color(0xff544646)
                                  ),
                            )
                          ],
                        )
                      : ListView.builder(
                          itemCount: cartFood.length,
                          itemBuilder: (context, index) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {},
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 4, sigmaY: 4),
                                                  child: AlertDialog(
                                                    title: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: "Montserrat",
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Do you want delete this food?",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Color(0xff707070),
                                                          fontFamily:
                                                              "Montserrat"),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop(false);
                                                          },
                                                          child: Text(
                                                            "No",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff707070),
                                                                fontFamily:
                                                                    "Montserrat"),
                                                          )),
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop(true);
                                                            Provider.of<CartItems>(
                                                                    context,
                                                                    listen: false)
                                                                .deleteFood(
                                                                    cartFood[
                                                                        index]);
                                                          },
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff707070),
                                                                fontFamily:
                                                                    "Montserrat"),
                                                          ))
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 10,
                                              left: 80,
                                              right: 20,
                                              bottom: 20),
                                          height: 110,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Container(
                                              padding: EdgeInsets.only(left: 50),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: 140,
                                                        child: Text(
                                                          cartFood[index].title,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  "Montserrat"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        width: 60,
                                                        child: Text(
                                                          "\₹${Decimal.parse((double.parse(cartFood[index].price)).toString()) * Decimal.parse(cartFood[index].quantity.toString())}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Color(
                                                                  0xff0A9400),
                                                              fontSize: 17,
                                                              fontFamily:
                                                                  "Montserrat"),
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
                                                                offset: Offset(0,
                                                                    2), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${cartFood[index].quantity}",
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
                                  ),
                                  Positioned(
                                    left: 12,
                                    top: 8,
                                    child: CachedNetworkImage(
                                      imageUrl: cartFood[index].image,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                      ),
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                ],
                              )),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
          floatingActionButton: cartFood.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      if (cartFood.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,

                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,

                          builder: (context) =>
                            StatefulBuilder(
                              builder: (context, setState) => Scaffold(
                                body: ModalProgressHUD(
                                  inAsyncCall:
                                      Provider.of<ModalHudProgress>(context)
                                          .isLoading,
                                  child: Form(
                                    key: _globalKey,
                                    child: SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Container(
                                              height: 60,
                                              child: Card(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                elevation: 3,
                                                semanticContainer: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12)),
                                                child: TextField(
                                                  controller: controller,
                                                  focusNode: focusNode,
                                                  onChanged: (value) {

                                                    setState(() {
                                                      name = value;

                                                    });
                                                    userName = value;
                                                  },
                                                  autocorrect: true,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Montserrat",
                                                    color: Color(0xff707070),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                      hintText: "Shope Name",
                                                      hintStyle:
                                                      TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                                                      border: InputBorder.none),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 200,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: (name != "" && name != null)
                                                  ? FirebaseFirestore.instance
                                                  .collection('ShopeNames')
                                                  .where("searchIndex", arrayContains: name)
                                                  .snapshots()
                                                  : FirebaseFirestore.instance
                                                  .collection("shopeNames")
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  List<AddShopeNameModel> _addShopeNameModel = [];
                                                  for (var doc in snapshot.data.docs) {
                                                    var data = doc.data();

                                                    _addShopeNameModel.add(AddShopeNameModel(
                                                      shopename: data["ShopeName"],
                                                    ));
                                                  }
                                                  return GridView.builder(
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 20, top: 10, bottom: 50),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 1, childAspectRatio: 4.90),
                                                      itemCount: snapshot.data.docs.length,
                                                      itemBuilder: (context, index) {
                                                        DocumentSnapshot data = snapshot.data.docs[index];
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              focusNode.unfocus();
                                                              controller.text = data.data()["ShopeName"];
                                                              routes = data.data()["Routes"];
                                                            });
                                                          },
                                                          child: Card(
                                                            elevation: 2,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(15)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(10),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    data.data()["ShopeName"],
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 18,
                                                                        fontFamily: "Montserrat"),
                                                                  ),
                                                                  Text(
                                                                    data.data()["Routes"],
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 10,
                                                                        fontFamily: "Montserrat"),
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

                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Container(
                                              height: 60,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(15),
                                              ),

                                              child: Center(
                                                child: Text(
                                                  routes??"",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 15,
                                                      fontFamily: "Montserrat"),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    color: Colors.redAccent),
                                                child: const Center(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await saveUserData(
                                                      userName: userName,
                                                      routes: routes)
                                                  .then((value) async {
                                                FirebaseFirestore _firestore =
                                                    FirebaseFirestore.instance;

                                                await _firestore
                                                    .collection("admin")
                                                    .doc(_auth.currentUser.uid)
                                                    .get()
                                                    .then((value) async {
                                                  snapshot1 = value;
                                                  snapshot = value;
                                                  print("hello" +
                                                      snapshot1
                                                          ?.data()['Routes']);
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder:
                                                          (BuildContext context) {
                                                        bool showCircle = false;

                                                        return StatefulBuilder(
                                                          builder: (context,
                                                                  setState1) =>
                                                              showCircle
                                                                  ? SimpleDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      title:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : BackdropFilter(
                                                                      filter: ImageFilter.blur(
                                                                          sigmaX:
                                                                              4,
                                                                          sigmaY:
                                                                              4),
                                                                      child:
                                                                          AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          "Place Order",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontFamily:
                                                                                "Montserrat",
                                                                          ),
                                                                        ),
                                                                        content:
                                                                            Text(
                                                                          "Do you want Place Order?",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontFamily:
                                                                                "Montserrat",
                                                                            color:
                                                                                Color(0xff707070),
                                                                          ),
                                                                        ),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(
                                                                                15),
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                              onPressed:
                                                                                  () {
                                                                                Navigator.of(context).pop(false);
                                                                              },
                                                                              child:
                                                                                  Text(
                                                                                "NO",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff707070), fontFamily: "Montserrat"),
                                                                              )),
                                                                          TextButton(
                                                                              onPressed:
                                                                                  () async {
                                                                                setState1(() {
                                                                                  showCircle = true;
                                                                                });
                                                                                await placeOrder(cartFood);
                                                                                setState1(() {
                                                                                  showCircle = false;
                                                                                });
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child:
                                                                                  Text(
                                                                                "Yes",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontFamily: "Montserrat"),
                                                                              ))
                                                                        ],
                                                                      )),
                                                        );
                                                      });
                                                });
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    color: Colors.black),
                                                child: const Center(
                                                  child: Text(
                                                    "Update Data",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        );
                      }
                    },
                    label: const Text(
                      'Place Your Order',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                          color: Colors.black),
                    ),
                    icon: const Icon(Icons_foodApp.order, color: Colors.black),
                    backgroundColor: Colors.white,
                  ),
                )
              : null),
    );
  }

  Future saveUserData({String userName, String routes}) async {
    var documentsRef =
        _firestore.collection("admin").doc(_auth.currentUser.uid);
    documentsRef.update({
      'UserName': controller.text,
      'Routes': routes,
    });
  }

  // mainBottomSheet(BuildContext context, List<FoodModel> foodModel){
  //
  //   var totalPrice = getTotalPrice(foodModel);
  //   final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  //
  //   showModalBottomSheet(
  //       isDismissible: true,
  //       isScrollControlled: true,
  //       enableDrag: true,
  //       context: context,
  //       builder: (BuildContext context){
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState){
  //             return  Form(
  //               key: _globalKey,
  //               child: SafeArea(
  //                 child: Container(
  //                   child: ListView(
  //                     children: <Widget>[
  //                       SizedBox(
  //                         height: 40,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Icon(
  //                               Icons_foodApp.order,
  //                             size: 35,
  //                           ),
  //                           SizedBox(
  //                             width: 5,
  //                           ),
  //                           Text(
  //                             "Checkout",
  //                             style: TextStyle(
  //                               fontSize: 30,
  //                                 fontFamily: "Montserrat"
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(15),
  //                         child: Container(
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                             children: [
  //                               Expanded(
  //                                 child: Container(
  //                                   height: 110,
  //                                   width: 110,
  //                                   child: Card(
  //                                     elevation: 0,
  //                                     clipBehavior: Clip.antiAliasWithSaveLayer,
  //                                     semanticContainer: true,
  //                                     shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(14)
  //                                     ),
  //                                     child: Column(
  //                                       crossAxisAlignment: CrossAxisAlignment.center,
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Text(
  //                                           "Total",
  //                                           style: TextStyle(
  //                                               fontSize: 12,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           "Price",
  //                                           style: TextStyle(
  //                                               fontSize: 17,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                         Row(
  //                                           mainAxisAlignment: MainAxisAlignment.center,
  //                                           children: [
  //                                             Text(
  //                                               "\$",
  //                                               style: TextStyle(
  //                                                   fontSize: 15,
  //                                                   color: Color(0xff0A9400),
  //                                                   fontFamily: "Montserrat"
  //                                               ),
  //                                             ),
  //                                             Text(
  //                                               totalPrice == null
  //                                               ? "0"
  //                                               : "$totalPrice",
  //                                               style: TextStyle(
  //                                                   fontSize: 23,
  //                                                   color: Color(0xff707070),
  //                                                   fontFamily: "Montserrat"
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(width: 10,),
  //                               Expanded(
  //                                 child: Container(
  //                                   height: 110,
  //                                   width: 110,
  //                                   child: Card(
  //                                     elevation: 0,
  //                                     clipBehavior: Clip.antiAliasWithSaveLayer,
  //                                     semanticContainer: true,
  //                                     shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(14)
  //                                     ),
  //                                     child: Column(
  //                                       crossAxisAlignment: CrossAxisAlignment.center,
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Text(
  //                                           "Total",
  //                                           style: TextStyle(
  //                                               fontSize: 12,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           "Quantity",
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           "${getTotalQuantity(foodModel)}",
  //                                           style: TextStyle(
  //                                               fontSize: 23,
  //                                               color: Color(0xff707070),
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(width: 10,),
  //                               Expanded(
  //                                 child: Container(
  //                                   height: 110,
  //                                   width: 110,
  //                                   child: Card(
  //                                     elevation: 0,
  //                                     clipBehavior: Clip.antiAliasWithSaveLayer,
  //                                     semanticContainer: true,
  //                                     shape: RoundedRectangleBorder(
  //                                         borderRadius: BorderRadius.circular(14)
  //                                     ),
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Text(
  //                                           "Shipping",
  //                                           style: TextStyle(
  //                                               fontSize: 12,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           "Price",
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontFamily: "Montserrat"
  //                                           ),
  //                                         ),
  //                                         Row(
  //                                           mainAxisAlignment: MainAxisAlignment.center,
  //                                           children: [
  //                                             Text(
  //                                               "\$",
  //                                               style: TextStyle(
  //                                                   fontSize: 15,
  //                                                   color: Color(0xff0A9400),
  //                                                   fontFamily: "Montserrat"
  //                                               ),
  //                                             ),
  //                                             Text(
  //                                               "${getShippingPrice(foodModel)}",
  //                                               style: TextStyle(
  //                                                   fontSize: 23,
  //                                                   color: Color(0xff707070),
  //                                                   fontFamily: "Montserrat"
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 18,right: 18),
  //                         child: TextFormField(
  //                           keyboardType: TextInputType.streetAddress,
  //                           onChanged: (val){
  //                             address = val;
  //                           },
  //                           validator: (value){
  //                             if(value.isEmpty){
  //
  //                               return "Address Recommended";
  //                               // ignore: missing_return
  //                             }
  //
  //                           },
  //                           style: TextStyle(
  //                               fontSize: 17,
  //                               fontWeight: FontWeight.bold,
  //                               fontFamily: "Montserrat",
  //                             color: Color(0xff707070),
  //                               // color: Color(0xff544646)
  //                           ),
  //                           decoration: InputDecoration(
  //                               contentPadding: EdgeInsets.only(left: 15),
  //                             hintText: "Address",
  //                             focusedBorder: OutlineInputBorder(
  //                               borderSide: const BorderSide(color: Color(0xffFFDB84), width: 2.0),
  //                               borderRadius: BorderRadius.circular(10),
  //                             ),
  //                             border :OutlineInputBorder(
  //                                 borderSide: const BorderSide(color: Colors.white, width: 2.0),
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 gapPadding: 10
  //                             ),
  //                           ),
  //
  //                         ),
  //                       ),
  //
  //                       SizedBox(
  //                         height: 40,
  //                       ),
  //                       GestureDetector(
  //                         onTap: (){
  //
  //                           if(_globalKey.currentState.validate()){
  //
  //                             _globalKey.currentState.save();
  //                             placeOrder(foodModel);
  //                           }
  //                         },
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(right: 80,left: 80),
  //                           child: Container(
  //                             height: 50,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(12),
  //                               color: Color(0xffFFDB84)
  //                             ),
  //                             child: Center(
  //                               child: Text(
  //                                 "Place Order",
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 16,
  //                                   color: Colors.black,
  //               fontFamily: "Montserrat"
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //         );
  //       }
  //   );
  // }

}
