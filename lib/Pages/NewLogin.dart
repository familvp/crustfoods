import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fooddeliveryapp/Firebase/FBAuth.dart';
import 'package:fooddeliveryapp/GlobalVariable/GlobalVariable.dart';
import 'package:fooddeliveryapp/Icons_illustrations/Icons_illustrations.dart';
import 'package:fooddeliveryapp/Pages/Home.dart';
import 'package:fooddeliveryapp/Provider/ModalHudProgress.dart';
import 'package:fooddeliveryapp/Widgets/DropDownMenu.dart';
import 'package:fooddeliveryapp/model/AddShopeNameModel.dart';
import 'package:fooddeliveryapp/model/DropDownMenuModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'MainPage.dart';

class NewLoginPage extends StatefulWidget {
  static String id = "NewLogin";

  @override
  _NewLoginPageState createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  FocusNode focusNode = FocusNode();
  String name = "";

  String userName, routes;




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
                      height: 0,
                    ),
                    Container(
                      height: 220,
                      width: 220,
                      child: SvgPicture.asset(signUp),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                    SizedBox(
                      height: 450,
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
                                        
                                      });
                                    },
                                    child: Card(
                                      elevation: 3,
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
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
