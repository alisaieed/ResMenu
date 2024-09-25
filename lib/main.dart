import 'package:ecommerce_app/Controllers/cart_provider.dart';
import 'package:ecommerce_app/Controllers/favorites_provider.dart';
import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';
import 'package:ecommerce_app/Controllers/meals_provider.dart';
import 'package:ecommerce_app/Controllers/orders_provider.dart';
import 'package:ecommerce_app/Controllers/search_provider.dart';
import 'package:ecommerce_app/Views/ui/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox("cart_box");
  await Hive.openBox("fav_box");

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
        ChangeNotifierProvider(create: (context) => MealNotifier()),
        ChangeNotifierProvider(create: (context) => FavoritesNotifier()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => SearchNotifier()),
        ChangeNotifierProvider(create: (context) => OrdersProvider())
      ],

      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            home: MainScreen(),
          );
        },
      )));
}
