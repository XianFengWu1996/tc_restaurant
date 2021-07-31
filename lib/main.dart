import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tc_restaurant/AllOrder/AllOrder.dart';
import 'package:tc_restaurant/Home/OrderPage.dart';
import 'package:tc_restaurant/Home/main.dart';
import 'package:tc_restaurant/Login/Login.dart';
import 'package:tc_restaurant/RestaurantBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantBloc(),
      child: GetMaterialApp(
        builder: EasyLoading.init(),
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: Login(),
        routes: {
          'new': (context) => Home(),
          'all': (context) => AllOrder(),
          'login': (context) => Login(),
        },
      ),
    );
  }
}