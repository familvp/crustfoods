import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String documentId;
  String orderNumber;
  double totalPrice;
  int totalQuantity;
  int shippingPrice;
  String phoneNumber;
  String userName;
  String routes;
  String orderStatus;
  Timestamp dateTime;
  List<dynamic> foodList;

  OrderModel(
      {this.documentId,
      this.orderNumber,
      this.totalPrice,
      this.totalQuantity,
      this.shippingPrice,
      this.phoneNumber,
      this.userName,
      this.routes,
      this.orderStatus,
      this.dateTime,
      this.foodList});
}
