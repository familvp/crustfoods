import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Firebase/DBFireStore.dart';
import 'package:fooddeliveryapp/Widgets/DropDownMenu.dart';
import 'package:fooddeliveryapp/model/AddFoodModel.dart';
import 'package:fooddeliveryapp/model/DropDownMenuModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFoodPage extends StatefulWidget {
  static String id = "AddFoodPage";

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  File _image;
  final picker = ImagePicker();
  final _fireStore = DBFireStore();

  String foodTitle, foodPrice, foodShortName;

  final List<DropDownMenuModel> _categoryList = [
    DropDownMenuModel(category: 'Bun'),
    DropDownMenuModel(category: 'PizzaBase'),
    DropDownMenuModel(category: 'Breads'),
    DropDownMenuModel(category: 'Cookies'),
    DropDownMenuModel(category: 'Kuboos'),
    DropDownMenuModel(category: 'Toast'),
  ];
  DropDownMenuModel _dropDownMenuModel = DropDownMenuModel();
  List<DropdownMenuItem<DropDownMenuModel>> _categoryNumberModelDropdownList;

  Future chooseFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  uploadFile() async {
    if (_image != null) {
      // store foodImages to FireBaseStorage
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("foodImages")
          .child("${randomAlphaNumeric(9)}.png");

      final StorageUploadTask task = storageReference.putFile(_image);

      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is URL ${downloadUrl}");

      // add Foods data to Cloud Firestore
      await _fireStore.addFoodItems(AddFoodModel(
          title: foodTitle,
          image: downloadUrl,
          price: foodPrice,
          shortname: foodShortName,
          category: _dropDownMenuModel.category));
    } else {}
  }

  List<DropdownMenuItem<DropDownMenuModel>> _buildPersonNumModelDropdown(
      List personList) {
    List<DropdownMenuItem<DropDownMenuModel>> items = List();
    for (DropDownMenuModel catgry in personList) {
      items.add(DropdownMenuItem(
        value: catgry,
        child: Row(
          children: [
            Icon(
              Icons.food_bank,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              catgry.category,
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
    _categoryNumberModelDropdownList =
        _buildPersonNumModelDropdown(_categoryList);
    _dropDownMenuModel = _categoryList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Add New Food",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "Montserrat"
                      // color: Color(0xff544646),
                      ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    chooseFile();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                        child: _image != null
                            ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Food Title is empty";
                        // ignore: missing_return
                      }
                    },
                    onSaved: (value) {
                      foodTitle = value;
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      color: Color(0xff707070),
                      // color: Color(0xff544646)
                    ),
                    decoration: InputDecoration(
                      hintText: "Food Title",
                      contentPadding: EdgeInsets.only(left: 20),
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Food Price is empty";
                        // ignore: missing_return
                      }
                    },
                    onSaved: (value) {
                      foodPrice = value;
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      color: Color(0xff707070),
                      // color: Color(0xff544646)
                    ),
                    decoration: InputDecoration(
                      hintText: "Food Price",
                      contentPadding: EdgeInsets.only(left: 20),
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Category",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        color: Color(0xff707070),
                        // color: Color(0xff544646)
                      ),
                    ),
                  ),
                ),
                DropDownMenu(
                  dropdownMenuItemList: _categoryNumberModelDropdownList,
                  onChanged: _onChangeFavouriteAddressModelDropdown,
                  value: _dropDownMenuModel,
                  isEnabled: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Food short name is empty";
                        // ignore: missing_return
                      }
                    },
                    onSaved: (value) {
                      foodShortName = value;
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      color: Color(0xff707070),
                      // color: Color(0xff544646)
                    ),
                    decoration: InputDecoration(
                      hintText: "Food short name",
                      contentPadding: EdgeInsets.only(left: 20),
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 10),
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
                          uploadFile();
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
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Upload Food",
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
                SizedBox(
                  height: 10,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
