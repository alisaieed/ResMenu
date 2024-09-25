import 'package:ecommerce_app/Controllers/favorites_provider.dart';
import 'package:ecommerce_app/Controllers/meals_provider.dart';
import 'package:ecommerce_app/Models/language.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/Shared/reuseableText.dart';
import 'package:ecommerce_app/Views/ui/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Shared/home_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    var mealsProvider = Provider.of<MealNotifier>(context, listen: false);
    // mealsProvider.getCategories(context);
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8.w, right: 5.w, bottom: 10.h),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReUseAbleText(
                              text:
                                  AppLocalizations.of(context)!.restaurantName,
                              style: appstyleWithHt(
                                  25, Colors.white, FontWeight.bold, 1.5),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
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
                      ReUseAbleText(
                        text: AppLocalizations.of(context)!.slogan,
                        style: appstyleWithHt(
                            23, Colors.white, FontWeight.bold, 1.2),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: mealsProvider.categories,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
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
                                appstyle(24, Colors.white, FontWeight.bold),
                            unselectedLabelColor: Colors.grey.withOpacity(0.3),
                            tabs: [
                              for (var cat
                                  in categories) // use snapshot.data to access your categories
                                Tab(
                                  text: cat,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
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
                                for (var index = 0; index < categories.length; index++)
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
