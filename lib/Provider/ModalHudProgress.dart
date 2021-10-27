
import 'package:flutter/material.dart';

class ModalHudProgress extends ChangeNotifier{

  bool isLoading = false;

  changeIsLoading(bool value){

    isLoading = value;
    notifyListeners();
  }
}