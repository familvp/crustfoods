import 'package:flutter/cupertino.dart';

class FoodModel {
  String image;
  String title;
  String shortname;
  String price;
  String category;
  int quantity;

  FoodModel(
      {this.image,
      this.title,
      @required this.shortname,
      this.price,
      this.category,
      this.quantity});
}
