import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Controllers/favorites_provider.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/ui/mainscreen.dart';
import 'package:ecommerce_app/Views/ui/meal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Shared/reuseableText.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  @override
  Widget build(BuildContext context) {
  var favoritesNotifier = Provider.of<FavoritesNotifier>(context);
  favoritesNotifier.getAllData();
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
        Container(
        padding:  EdgeInsets.fromLTRB(16.w, 45.h, 0.w, 0.h),
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("android/assets/images/Asset 2.png"),
                fit: BoxFit.fill)
        ),
          child: Padding(
            padding:  EdgeInsets.all(8.h),
            child: ReUseAbleText(
              text: AppLocalizations.of(context)!.myFavorites, style:
              appstyle(28, Colors.white, FontWeight.bold),),
          ),
        ),
            Padding(padding:  EdgeInsets.only(left: 8.w, right: 8.w, top: 20.h, bottom: 8.h),
            child: ListView.builder(
                itemCount: favoritesNotifier.fav.length,
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.124),
                itemBuilder: (BuildContext context, index){
                  final meal = favoritesNotifier.fav[index];
                  return Padding(
                      padding:  EdgeInsets.all(8.h),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            spreadRadius: 5,
                            blurRadius: 0.3,
                            offset: const Offset(0,1),
                          )
                        ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder:
                                  (context) => MealPage(id: meal['id'], category: meal['category']),));
                            },
                            child: Row(
                              children: [
                                Padding(
                                    padding:  EdgeInsets.all(12.h),
                                  child: CachedNetworkImage(imageUrl: meal['imageUrl'],
                                    width: MediaQuery.of(context).size.width*0.187,
                                    height: MediaQuery.of(context).size.height*0.87,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 12.h, left: 20.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ReUseAbleText(
                                        text: meal['name'],
                                      style: appstyle(16, Colors.black, FontWeight.bold),),
                                       SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(meal['category'],
                                      style: appstyle(14, Colors.grey, FontWeight.w600),),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ReUseAbleText(
                                            text: "${meal['price']}",
                                          style: appstyle(14, Colors.black, FontWeight.bold),),
                                        ],
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                          Padding(
                              padding:  EdgeInsets.all(8.h),
                            child: GestureDetector(
                              onTap: () {
                                favoritesNotifier.deleteFav(meal['key']);
                                favoritesNotifier.ids.removeWhere((element) => element == meal['id']);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                              },
                              child: const Icon(Ionicons.heart_dislike_sharp),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  );
                })
            ),
          ]
        ),
      )
    );
  }
}
