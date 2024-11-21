import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Controllers/meals_provider.dart';
import 'package:ecommerce_app/Views/ui/meal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Controllers/search_provider.dart';
import '../../Models/meal_model.dart';
import '../Shared/appstyle.dart';
import '../Shared/reuseableText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {

   // List<Meals> allMeals = [];
  // late var mealsNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // mealsNotifier = Provider.of<MealNotifier>(context, listen: false);
      // allMeals = await mealsNotifier.getAllMeals(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mealsNotifier = Provider.of<MealNotifier>(context, listen: false);
    var allMeals = mealsNotifier.allMealsList;
    TextEditingController controller = TextEditingController();

     Future <List<Meals>>? searchResult;

    return Consumer<SearchNotifier>(builder: (context, searchNotifier, child) {
      return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: MediaQuery.of(context).size.height*0.124,
            backgroundColor: Colors.black,
            elevation: 0,
            title: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.mealSearch,
                  hintStyle: TextStyle(
                    fontSize: 18.h
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: GestureDetector(
                      onTap: () async {
                        searchResult?.then(
                          (list){
                           list.clear();
                          }
                        );
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 18,
                      )),
                  prefixIconColor: Colors.black,
                  suffixIcon: GestureDetector(
                      onTap: () async {
                        searchResult?.then(
                                (list){
                              list.clear();
                            }
                        );
                        String text = controller.text;
                        searchResult = searchNotifier.searchItem(text, allMeals);
                      },
                      child: const Icon(Icons.search)),
                  suffixIconColor: Colors.black,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
              cursorColor: Colors.white,
              controller: controller,
              keyboardType: TextInputType.text,
              onEditingComplete: () async {
                searchResult?.then(
                        (list){
                      list.clear();
                    }
                );
                String text = controller.text;
                searchResult = searchNotifier.searchItem(text, allMeals);
              },
            ),
          ),
          body:

          Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  FutureBuilder<List<Meals>>(
                    future: searchResult,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Meals>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        return const Center(
                            child: Icon(
                              Icons.search,
                              size: 40,
                              color: Colors.black12,
                            ));
                      }
                      else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      } else {
                        if (snapshot.data!.isEmpty) {
                          
                          return Container(
                            height: MediaQuery.of(context).size.height*0.074,
                            padding: EdgeInsets.only(top: 8.h, left: 5.h),
                            child: Row(
                              children: [
                                ReUseAbleText(
                                  text:
                                  AppLocalizations.of(context)!.notFound , style: appstyle(20, Colors.black, FontWeight.bold),
                                ),
                                 SizedBox(
                                  width: 5.w,
                                ),
                                const Icon(

                                  Icons.search_off, size: 25,
                                )
                              ],
                            ),
                          );
                          
                        } else {

                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var meal = snapshot.data?[index];
                                return Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MealPage(
                                                    id: meal.id,
                                                    name: meal.name,
                                                    category: meal.category)));
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*0.14,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade500,
                                                  spreadRadius: 5,
                                                  blurRadius: 0.3,
                                                  offset: const Offset(0, 1),
                                                )
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                                                    child: CachedNetworkImage(
                                                      imageUrl: meal?.imageUrl[0],
                                                      width: MediaQuery.of(context).size.width*0.1867,
                                                      height: MediaQuery.of(context).size.height*0.0863,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 12.h, left: 20.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        ReUseAbleText(
                                                          text: meal!.name,
                                                          style: appstyle(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          meal.category,
                                                          style: appstyle(
                                                              14,
                                                              Colors.grey,
                                                              FontWeight.w600),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            ReUseAbleText(
                                                              text:
                                                              meal.price,
                                                              style: appstyle(
                                                                  14,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              });
                        }
                      }
                    },
                  )));
    });
  }
}
