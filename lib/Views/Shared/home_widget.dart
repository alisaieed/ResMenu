import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/Shared/meal_card.dart';
import 'package:ecommerce_app/Views/Shared/reuseableText.dart';
import 'package:ecommerce_app/Views/ui/meal_page.dart';
import 'package:ecommerce_app/Views/ui/meals_by_cat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Controllers/meals_provider.dart';
import '../../Models/meal_model.dart';
import '../Shared/new_meal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeWidget extends StatefulWidget {
  final String mealCategory;
  final int tabIndex;

  const HomeWidget(
      {super.key, required this.mealCategory, required this.tabIndex});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    var mealsProvider = Provider.of<MealNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.405,
            child: FutureBuilder<List<Meals>>(
              future: mealsProvider.allMeals,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Meals>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final meals = snapshot.data;
                  return ListView.builder(
                      itemCount: meals!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final meal = meals[index];

                        if (meal.category == widget.mealCategory) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MealPage(
                                          id: meal.id,
                                          category: meal.category)));
                            },
                            child: MealCard(
                              price: "\$${meal.price}",
                              category: meal.category,
                              id: meal.id,
                              name: meal.name,
                              image: meal.imageUrl[0],
                              components: meal.components,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      });
                }
              },
            )),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MealsByCat(
                                  tabIndex: widget.tabIndex,
                                  tabs: mealsProvider.categoriesList.length,
                                  category: widget.mealCategory,
                                )));
                  },
                  child: Row(
                    children: [
                      ReUseAbleText(
                        text: AppLocalizations.of(context)!.showAll,
                        style: appstyle(16, Colors.black, FontWeight.w500),
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 20.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReUseAbleText(
                    text: AppLocalizations.of(context)!.latestMeals,
                    style: appstyle(18, Colors.black, FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            child: FutureBuilder<List<Meals>>(
              future: mealsProvider.lastAddedMeals,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Meals>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final meals = snapshot.data;
                  return ListView.builder(
                      itemCount: meals?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MealPage(
                                        id: meals[index].id,
                                        category: meals[index].category),
                                  ));
                            },
                            child: NewMeal(
                              imageUrl: meals?[index].imageUrl[1],
                              name: meals![index].name,
                            ),
                          ),
                        );
                      });
                }
              },
            ))
      ],
    );
  }
}
