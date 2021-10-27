
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/model/foodModel.dart';

class CartItems extends ChangeNotifier{

  List<FoodModel> foodModel = [];

  addFood(FoodModel food){

    foodModel.add(food);
    notifyListeners();
  }

  deleteFood(FoodModel fdModel){

    foodModel.remove(fdModel);
    notifyListeners();

  }

  void deleteAllFoods() {
    foodModel.clear();
    notifyListeners();
  }

  int get itemCount {
    return foodModel.length;
  }

}