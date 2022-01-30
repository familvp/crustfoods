import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Pages/Home.dart';
import 'package:fooddeliveryapp/Provider/ModalHudProgress.dart';
import 'package:fooddeliveryapp/Widgets/DropDownMenu.dart';
import 'package:fooddeliveryapp/model/AddShopeNameModel.dart';
import 'package:fooddeliveryapp/model/DropDownMenuModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'MainPage.dart';

class UserEditPage extends StatefulWidget {
  static String id = "UserEdit";

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _fireStore = DBFireStore();

  String shopename, routes;
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
  addShopeName () async{
    await _fireStore.addShopeName(AddShopeNameModel(
      shopename: shopename,
      routes: _dropDownMenuModel.routesNum,));
  }
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
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Add Shop Name",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(
                  height: 180,
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
                      onChanged: (value) {
                        shopename = value;
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
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.redAccent),
                      child: const Center(
                        child: Text(
                          "Cancel",
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
                SizedBox(
                  height: 20,
                ),
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () async {
                      if (_globalKey.currentState.validate()) {
                        try {
                          _globalKey.currentState.save();
                          addShopeName();
                          Navigator.pop(context);
                        } catch (ex) {
                          // ignore: deprecated_member_use
                          Scaffold.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              "Uploading Fail!",
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 30,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Upload Data",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
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
}
