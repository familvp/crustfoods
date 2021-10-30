import 'package:cloud_firestore/cloud_firestore.dart';

class OrderSheetModel {
  static List<String> rowcontent;
  static final String userName = "shopName";
  static final String foodName = "foodName";
  static final String quantity = "quantity";
  static final String date = "date";
  static List<String> rowtittles = [userName];
  static Future fetchTitles() async {
    await FirebaseFirestore.instance.collection("foods").get().then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        rowtittles.add(value.docs[i]['foodTitle']);
        print(value.docs[i]['foodTitle']);
      }
    });
  }

//   OrderSheetModel({
//     this.id, this.address, this.foodName, this.userName,
//     this.quantity, this.price, this.date
// });

  static Future<List<String>> getFields() async {
    await fetchTitles();
    return rowtittles;
  }
}
