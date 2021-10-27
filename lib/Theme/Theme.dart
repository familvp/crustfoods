import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{

  ThemeData _selectTheme;


  ThemeData light = ThemeData.light().copyWith(

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
          color: Colors.black,

      )
    ),

    accentColor: Color(0xff212226),

    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        color: Colors.white
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          color: Colors.black
      ),
      bodyText2: TextStyle(
          color: Colors.black
      ),
    ),

    cardTheme: CardTheme(
      color: Colors.white,
    )

  );

  ThemeData dark = ThemeData.dark().copyWith(

      dialogBackgroundColor: Color(0xff212226),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
           color: Colors.white
        ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.black12
    ),

    scaffoldBackgroundColor: Color(0xff121417),
      appBarTheme: AppBarTheme(
        color: Color(0xff121417),
      ),
       cardTheme: CardTheme(
         color: Color(0xff212226)
       ),

    accentColor: Color(0xff212226),


    textTheme: TextTheme(
      bodyText1: TextStyle(
          color: Colors.white
      ),

    ),

       // primaryColor: Color(0xff212429),
  );


  ThemeProvider({bool isDarkMode}){

    try{
      if(isDarkMode == null){
        _selectTheme = light;
      }else{
        _selectTheme = isDarkMode ? dark : light;
      }

    }catch(e){
      print(e.toString());
    }
  }


  Future<void> swapTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_selectTheme == dark) {
      _selectTheme = light;
      preferences.setBool("isDarkTheme", false);
    }
    else {
      _selectTheme = dark;
      preferences.setBool("isDarkTheme", true);

    }
    notifyListeners();
  }

  ThemeData get getTheme =>_selectTheme;
}