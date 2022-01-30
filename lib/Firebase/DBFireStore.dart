import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fooddeliveryapp/GlobalVariable/GlobalVariable.dart';
import 'package:fooddeliveryapp/model/AddFoodModel.dart';
import 'package:fooddeliveryapp/model/AddShopeNameModel.dart';

class DBFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> loadFoods() {
    return _firestore.collection("foods").snapshots();
  }

  // Stream<QuerySnapshot> loadUserInfo() {
  //
  //   final User user = _auth.currentUser;
  //   final uid = user.uid;
  //
  //   return _firestore.collection("newUser").doc(uid).snapshots();
  //
  // }

  Stream<QuerySnapshot> loadOrdersForUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;

    return _firestore
        .collection("admin")
        .doc(uid)
        .collection("orders")
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    String uid = _auth.currentUser.uid;

    return _firestore
        .collection("admin")
        .doc(uid)
        .collection("orders")
        .doc(documentId)
        .collection("orderDetails")
        .snapshots();
  }

  saveOrderForUser(orders) {
    final User user = _auth.currentUser;
    final uid = user.uid;

    var userOrder = _firestore.collection("admin").doc(uid);
    var orderUser = userOrder.collection("orders").doc();
    orderUser.set(orders);
  }

  Future saveOrderForAdmin(Map<String, dynamic> orders) async {
    final User user = _auth.currentUser;
    final String uid = user.uid;
    await _firestore.collection("OrderHistory").doc(uid).set(
          orders,
        );
  }
  Stream<QuerySnapshot> loadOrdersHistory() {
    return _firestore.collection("OrderHistory").snapshots();
  }

  addFoodItems(AddFoodModel addFoodModel) async {
    List<String> splitList = addFoodModel.title.split(" ");

    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + i; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    await _firestore.collection("foods").doc().set({
      "foodImage": addFoodModel.image,
      "foodTitle": addFoodModel.title,
      "foodPrice": addFoodModel.price,
      "foodShortName": addFoodModel.shortname,
      "foodCategory": addFoodModel.category,
      "searchIndex": indexList,
    });
  }

  updateFoodItem(AddFoodModel addFoodModel, documentID) async {
    List<String> splitList = addFoodModel.title.split(" ");

    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + i; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    await _firestore.collection("foods").doc(documentID).update({
      "foodImage": addFoodModel.image,
      "foodTitle": addFoodModel.title,
      "foodPrice": addFoodModel.price,
      "foodShortName": addFoodModel.shortname,
      "foodCategory": addFoodModel.category,
      "searchIndex": indexList,
    });
  }

  deleteFoods(documentId) {
    _firestore.collection("foods").doc(documentId).delete();

  }
  addShopeName(AddShopeNameModel addShopeNameModel) async {
    List<String> splitList = addShopeNameModel.shopename.split(" ");

    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + i; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    await _firestore.collection("ShopeNames").doc().set({
      'ShopeName': addShopeNameModel.shopename,
      'Routes': addShopeNameModel.routes,
      "searchIndex": indexList,
    });
  }
}
