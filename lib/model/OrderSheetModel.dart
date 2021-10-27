class OrderSheetModel {
  static final String userName = "shopName";
  static final String foodName = "foodName";
  static final String quantity = "quantity";
  static final String date = "date";

//   OrderSheetModel({
//     this.id, this.address, this.foodName, this.userName,
//     this.quantity, this.price, this.date
// });

  static List<String> getFields() => [foodName, userName, quantity, date];
}

class OrderSheet {
  final String foodName;
  final String userName;
  final int quantity;
  final DateTime date;

  OrderSheet({this.foodName, this.userName, this.quantity, this.date});

  Map<String, dynamic> toJson() => {
        OrderSheetModel.foodName: foodName,
        OrderSheetModel.userName: userName,
        OrderSheetModel.quantity: quantity,
        OrderSheetModel.date: date,
      };
}
