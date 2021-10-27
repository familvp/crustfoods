import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FBAuth {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  saveUserData(String userName, String phoneNumber, String routes) async {
    var documentsRef =
        _firestore.collection("newUser").doc(_auth.currentUser.uid);
    documentsRef.set({
      'UserName': userName,
      'PhoneNumber': phoneNumber,
      'Routes': routes,
    });
  }

  Future<void> saveCurrentUser() async {
    return await _auth.currentUser.uid;
  }

  Future<User> getUser() async {
    return await _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
