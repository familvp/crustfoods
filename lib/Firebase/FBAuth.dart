import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FBAuth {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserCredential> signUp(String email, String password, String userName,
      String phoneNumber, String routes) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await saveUserData(userName, email, phoneNumber, routes);

    return authResult;
  }

  Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return authResult;
  }

  Future saveUserData(
      String userName, String email, String phoneNumber, String routes) async {
    var documentsRef =
    _firestore.collection("admin").doc(_auth.currentUser.uid);
    documentsRef.set({
      'UserName': userName,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'Routes': routes,
    });
  }

  Future<void> saveCurrentUser() async {
    return await _auth.currentUser.uid;
  }

  User getUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
