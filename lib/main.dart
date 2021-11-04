import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddeliveryapp/Google%20Sheet%20Api/GSheetApi.dart';
import 'package:fooddeliveryapp/Pages/AboutUs.dart';
import 'package:fooddeliveryapp/Pages/CartPage.dart';
import 'package:fooddeliveryapp/Pages/OrderDetails.dart';
import 'package:fooddeliveryapp/Pages/SignInPage.dart';
import 'package:fooddeliveryapp/Provider/CartItem.dart';
import 'package:fooddeliveryapp/Provider/ModalHudProgress.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/MainPage.dart';
import 'Pages/OnBoardingScreens.dart';
import 'Theme/Theme.dart';

// remember me sign in
bool rememberMe = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GSheetApi().init();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  rememberMe = await preferences.getBool("rememberMe");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CartItems>(
        create: (context) => CartItems(),
      ),
      ChangeNotifierProvider<ModalHudProgress>(
        create: (context) => ModalHudProgress(),
      ),
    ],
    child: ChangeNotifierProvider(
        create: (context) =>
            ThemeProvider(isDarkMode: preferences.getBool("isDarkTheme")),
        child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Consumer<ThemeProvider>(builder: (context, themProvider, child) {
      return MaterialApp(
        theme: themProvider.getTheme,
        debugShowCheckedModeBanner: false,
        // OnBoarding open one time
        initialRoute: rememberMe == true ? MainPage.id : OnBoardingScreens.id,
        routes: {
          OnBoardingScreens.id: (context) => OnBoardingScreens(),
          CartPage.id: (context) => CartPage(),
          OrderDetails.id: (context) => OrderDetails(),
          AboutUs.id: (context) => AboutUs(),
          SignInPage.id: (context) => SignInPage(),
          MainPage.id: (context) => MainPage(),
        },
      );
    });
  }
}
