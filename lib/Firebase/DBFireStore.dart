import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        .collection("newUser")
        .doc(uid)
        .collection("orders")
        .snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    String uid = _auth.currentUser.uid;

    return _firestore
        .collection("newUser")
        .doc(uid)
        .collection("orders")
        .doc(documentId)
        .collection("orderDetails")
        .snapshots();
  }

  saveOrderForUser(orders) {
    final User user = _auth.currentUser;
    final uid = user.uid;

    var userOrder = _firestore.collection("newUser").doc(uid);
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
}
