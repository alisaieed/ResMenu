import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';
import 'package:ecommerce_app/Views/ui/login_page.dart';
import 'package:ecommerce_app/Views/ui/order_list.dart';
import 'package:ecommerce_app/Views/ui/favorites.dart';
import 'package:ecommerce_app/Views/ui/homepage.dart';
import 'package:ecommerce_app/Views/ui/orders_page.dart';
import 'package:ecommerce_app/Views/ui/searchpage.dart';
import 'package:ecommerce_app/Views/ui/settings_page.dart';
import 'package:ecommerce_app/Views/ui/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controllers/firebase_messaging.dart';
import '../Shared/BottomNavBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MainScreen extends StatefulWidget {
   const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();

   static void setLocale(BuildContext context, Locale newLocale){
     _MainScreenState? state = context.findAncestorStateOfType<_MainScreenState>();
     state?.setLocale(newLocale);
   }

}

class _MainScreenState extends State<MainScreen> {


  Locale? _locale;

  setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
    setState(() {
      _locale = locale;
    });
  }

  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language_code') ?? 'en';
    String countryCode = prefs.getString('country_code') ?? '';
    setState(() {
      _locale = Locale(languageCode, countryCode);
    });
  }

  List<Widget> pageList = [
    const HomePage(),
    const SearchPage(),
    const Favorites(),
    const CartPage(),
    const OrdersPage(),
    const LoginPage(),
    const SignupPage(),
    const SettingsPage()
  ];

  @override
  void initState() {
    loadLocale();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showDialog(context: context, builder:
            (BuildContext context) {
          return AlertDialog(
            content:  Text(
                "${message.notification!.body}"),
            contentPadding: const EdgeInsets.all(12),
            actions: [
              TextButton(
                  onPressed: () {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrdersPage(),));
                    var mainNotifier = Provider.of<MainScreenNotifier>(context, listen: false);
                    mainNotifier.pageIndex = 4;
                    Navigator.pop(context);
                  },
                  child:  const Text(
                    "Show Orders.",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:  const Text(
                    "Close.",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        },);
      }
    });
    super.initState();
    request_Permission();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
Widget build(BuildContext context){
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child){
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
          home: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: const Color(0xFFE2E2E2),
              body: pageList[mainScreenNotifier.pageIndex],

              bottomNavigationBar: const BottomNavBar(),
            ),
          ),
        );
      }
    );
}
}

