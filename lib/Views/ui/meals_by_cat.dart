import "package:ecommerce_app/Models/meal_model.dart";
import "package:ecommerce_app/Views/Shared/category_btn.dart";
import "package:ecommerce_app/Views/Shared/custom_spacer.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:provider/provider.dart";
import "../../Controllers/meals_provider.dart";
import "../Shared/appstyle.dart";
import "../Shared/latest_meals.dart";
import "../Shared/reuseableText.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealsByCat extends StatefulWidget {
  const MealsByCat(
      {super.key,
      required this.tabIndex,
      required this.tabs,
      required this.category});

  final int tabIndex;
  final int tabs;
  final String category;

  @override
  State<MealsByCat> createState() => _MealsByCatState();
}

class _MealsByCatState extends State<MealsByCat> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
      length: widget.tabs, vsync: this, initialIndex: widget.tabIndex);

  @override
  void initState() {
    super.initState();
    _tabController.animateTo(widget.tabIndex);
  }

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    var mealsNotifier = Provider.of<MealNotifier>(context);

    List<Widget> children = mealsNotifier.categoriesList.map((category) {
      List<Meals> categoryMeals = mealsNotifier.allMealsList
          .where((meal) => meal.category == category)
          .toList();

      return LatestMeals(
        category: categoryMeals,
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 45.h, 0.w, 0.h),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("android/assets/images/Asset 2.png"),
                      fit: BoxFit.fill)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(6.w, 5.h, 16.w, 18.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            filter();
                          },
                          child: const Icon(
                            Icons.sort,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      labelStyle: appstyle(20, Colors.white, FontWeight.bold),
                      unselectedLabelColor: Colors.grey.withOpacity(0.3),
                      tabs: [
                        for (var category in mealsNotifier.categoriesList)
                          SizedBox(height: isTablet(context)?100:40, child: Tab(text: category)),
                      ]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                left: MediaQuery.of(context).size.width * 0.0427,
                right: MediaQuery.of(context).size.width * 0.032,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: TabBarView(
                  controller: _tabController,
                  children: children,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> filter() {
    double value = 100;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.white54,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.74,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 5.h,
                    width: MediaQuery.of(context).size.width * 0.107,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.727,
                    child: Column(
                      children: [
                        const CustomSpacer(),
                        Text(
                          AppLocalizations.of(context)!.filter,
                          style: appstyle(35, Colors.black, FontWeight.bold),
                        ),
                        const CustomSpacer(),
                        ReUseAbleText(
                          text: AppLocalizations.of(context)!.category,
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CategoryBtn(
                              buttonClr: Colors.black,
                              label: AppLocalizations.of(context)!.eastern,
                            ),
                            CategoryBtn(
                                buttonClr: Colors.grey,
                                label: AppLocalizations.of(context)!.western),
                            CategoryBtn(
                                buttonClr: Colors.grey,
                                label: AppLocalizations.of(context)!.drinks),
                          ],
                        ),
                        const CustomSpacer(),
                        const CustomSpacer(),
                        Text(
                          AppLocalizations.of(context)!.price,
                          style: appstyle(20, Colors.black, FontWeight.bold),
                        ),
                        Slider(
                            value: value,
                            activeColor: Colors.black,
                            inactiveColor: Colors.grey,
                            thumbColor: Colors.black,
                            max: 500,
                            divisions: 50,
                            label: value.toString(),
                            secondaryTrackValue: 200,
                            onChanged: (double value) {}),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
