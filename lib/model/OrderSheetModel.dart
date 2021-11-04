import 'package:cloud_firestore/cloud_firestore.dart';

class OrderSheetModel {
  static final String userName = "shopName";

  final String date = "date";
  final List<String> rowtittles = [
    userName,
  ];
  Future fetchTitles() async {
    await FirebaseFirestore.instance.collection("foods").get().then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        rowtittles.add(value.docs[i]['foodshortname']);
      }
    });
  }

//   OrderSheetModel({
//     this.id, this.address, this.foodName, this.userName,
//     this.quantity, this.price, this.date
// });

  Future<List<String>> getFields() async {
    await fetchTitles();
    return rowtittles;
  }
}
