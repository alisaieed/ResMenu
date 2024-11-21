import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Controllers/favorites_provider.dart';
import 'package:ecommerce_app/Controllers/meals_provider.dart';
import 'package:ecommerce_app/Models/language.dart';
import 'package:ecommerce_app/Models/restaurantID.dart';
import 'package:ecommerce_app/Services/helper.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/ui/editRestaurant.dart';
import 'package:ecommerce_app/Views/ui/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Shared/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  Helper helper = Helper();
  late Restaurant _restaurant;

  Future<void> showEditResDialog() async {
    final locale = Localizations.localeOf(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Localizations.override(
            context: context,
            locale: locale,
            child: EditRestaurantPage(),
          ),
        );
      },
    );
  }

  Future<void> _loadData() async {
    var restaurant = await helper.loadRestaurantData();
    if (restaurant == null ||
        restaurant.restaurantNameAR == '' ||
        restaurant.restaurantNameEN == '' ||
        restaurant.logo == "") {
      showEditResDialog();
    } else {
      setState(() {
        _restaurant = restaurant;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _restaurant = Restaurant(
      restaurantNameEN: '',
      restaurantNameAR: '',
      logo: '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    _loadData();
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600; // Adjust the threshold as needed
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);

    var mealsProvider = Provider.of<MealNotifier>(context, listen: false);

    mealsProvider.getAllMeals(context);
    mealsProvider.getLastAddedMeals(context);
    var favoritesProvider = Provider.of<FavoritesNotifier>(context);
    favoritesProvider.getFavorites();
    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10.w, 0.0.h, 0, 0),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("android/assets/images/Asset 2.png"),
                      fit: BoxFit.fill)),
            ),
            ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8.w, right: 5.w, bottom: 10.h),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _restaurant.logo != ""
                                ? CachedNetworkImage(
                                    imageUrl: _restaurant
                                        .logo, // URL from Firebase Storage
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    width: MediaQuery.of(context).size.width *
                                        0.29,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        width: 20, // Custom width
                                        height: 20, // Custom height
                                        child: CircularProgressIndicator(
                                          color: Colors.white, // Custom color
                                          strokeWidth: 4, // Custom stroke width
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: _restaurant.logo != ""
                                  ? const EdgeInsets.only(
                                      right: 10.0, top: 25.0)
                                  : const EdgeInsets.only(right: 10.0),
                              child: DropdownButton(
                                  underline: const SizedBox(),
                                  icon: const Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  items: Language.languageList()
                                      .map<DropdownMenuItem<Language>>((e) =>
                                          DropdownMenuItem<Language>(
                                            value: e,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  e.flag,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  e.name,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (Language? language) {
                                    if (language != null) {
                                      MainScreen.setLocale(context,
                                          Locale(language.languageCode, ''));
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: mealsProvider.categories,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var categories = snapshot.data;

                      _tabController =
                          TabController(length: categories.length, vsync: this);

                      List<Widget> homeWidgets =
                          categories.asMap().entries.map<Widget>((entry) {
                        int index = entry.key;
                        String category = entry.value;
                        return HomeWidget(
                          key: ValueKey(category), // Add this line
                          mealCategory: category,
                          tabIndex: index,
                        );
                      }).toList();

                      return Column(
                        children: [
                          TabBar(
                            padding: EdgeInsets.zero,
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: Colors.white,
                            labelStyle:
                                appstyle(isTablet(context)?20:24, Colors.white, FontWeight.bold),
                            unselectedLabelColor: Colors.grey.withOpacity(0.3),
                            tabs: [
                              for (var cat
                                  in categories) // use snapshot.data to access your categories
                                Tab(
                                  text: cat,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.62,
                            // padding: const EdgeInsets.only(
                            //     left: 12, top: 10),
                            child: TabBarView(
                              controller: _tabController,
                              children:
                                  // homeWidgets
                                  [
                                for (var index = 0;
                                    index < categories.length;
                                    index++)
                                  HomeWidget(
                                    mealCategory: categories[index],
                                    tabIndex: index,
                                  ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  },
                )
              ],
            )
          ],
        ));
  }
}
