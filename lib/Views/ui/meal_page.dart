import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Controllers/favorites_provider.dart';
import 'package:ecommerce_app/Controllers/meals_provider.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/ui/favorites.dart';
import 'package:ecommerce_app/Views/ui/mainscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../Controllers/cart_provider.dart';
import '../Shared/check_out.dart';
import '../Shared/reuseableText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';

class MealPage extends StatefulWidget {
  const MealPage(
      {super.key,
      required this.id,
      required this.category,
      required this.name});

  final String id;
  final String name;
  final String category;

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final PageController pageController = PageController();

  List<String> options = [];
  int qty = 1;
  var activePage = 0;

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);

    var favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: true);
    favoritesNotifier.getFavorites();

    var cartNotifier = Provider.of<CartProvider>(context);
    cartNotifier.getCart();

    var mealNotifier = Provider.of<MealNotifier>(context);
    mealNotifier.getMeals(widget.category, widget.id);

    var mainScreenNotifier = Provider.of<MainScreenNotifier>(context);

    return Scaffold(body: Consumer<MealNotifier>(
      builder: (context, mealsNotifier, child) {
        var meal = mealNotifier.meal;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              leadingWidth: 0,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: null,
                      child: const Icon(
                        Ionicons.ellipsis_horizontal,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
              snap: false,
              floating: true,
              backgroundColor: Colors.transparent,
              expandedHeight: MediaQuery.of(context).size.height,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: meal.imageUrl.length,
                          controller: pageController,
                          onPageChanged: (page) {
                            activePage = page;
                          },
                          itemBuilder: (context, int index) {
                            return Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.39,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey.shade300,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.211,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.scaleDown,
                                            image: CachedNetworkImageProvider(
                                              meal.imageUrl[index],
                                            ))),
                                  ),
                                ),
                                Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.09,
                                    right: MediaQuery.of(context).size.width *
                                        0.054,
                                    child: Consumer<FavoritesNotifier>(builder:
                                        (context, favoritesNotifier, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (favoritesNotifier.names
                                              .contains(widget.name)) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Favorites()));
                                          } else {
                                            favoritesNotifier.createFav({
                                              "id": meal.id,
                                              "name": meal.name,
                                              "category": meal.category,
                                              "price": meal.price,
                                              "imageUrl": meal.imageUrl[0],
                                            });
                                          }
                                          setState(() {});
                                        },
                                        child: favoritesNotifier.names
                                                .contains(meal.name)
                                            ? const Icon(
                                                CupertinoIcons.heart_circle)
                                            : const Icon(CupertinoIcons.heart),
                                      );
                                    })),
                                Positioned(
                                    bottom: 0.h,
                                    right: 0.w,
                                    left: 0.w,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List<Widget>.generate(
                                          meal.imageUrl.length,
                                          (index) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        activePage == index
                                                            ? Colors.black
                                                            : Colors.grey),
                                              )),
                                    )),
                              ],
                            );
                          }),
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.04,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.62,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ReUseAbleText(
                                        text: meal.name,
                                        style: appstyle(
                                            16, Colors.black, FontWeight.bold),
                                      ),
                                      ReUseAbleText(
                                        text: " \\ \$${meal.price}",
                                        style: appstyle(
                                            14, Colors.black, FontWeight.w600),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  qty++;
                                                  setState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.add_box,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                child: Text(
                                                  "$qty",
                                                  style: appstyle(
                                                      14,
                                                      Colors.black,
                                                      FontWeight.w600),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (qty > 1) {
                                                    qty--;
                                                    setState(() {});
                                                  }
                                                },
                                                child: qty > 1
                                                    ? const Icon(
                                                        Icons
                                                            .indeterminate_check_box,
                                                        size: 16,
                                                        color: Colors.black,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .indeterminate_check_box,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ReUseAbleText(
                                        text: meal.category,
                                        style: appstyle(
                                            12, Colors.grey, FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ReUseAbleText(
                                            text: AppLocalizations.of(context)!
                                                .components,
                                            style: appstyle(12, Colors.black,
                                                FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          SizedBox(
                                            width: locale.languageCode == 'ar'
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.70
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.037,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: meal.components.length,
                                              itemBuilder: (context, index) {
                                                if (index ==
                                                    meal.components.length -
                                                        1) {
                                                  return Center(
                                                    child: ReUseAbleText(
                                                        text: meal
                                                            .components[index],
                                                        style: appstyle(
                                                            12,
                                                            Colors.black,
                                                            FontWeight.normal)),
                                                  );
                                                } else {
                                                  return Center(
                                                    child: ReUseAbleText(
                                                        text:
                                                            "${meal.components[index]}, ",
                                                        style: appstyle(
                                                            12,
                                                            Colors.black,
                                                            FontWeight.normal)),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.012,
                                      ),
                                      meal.options!.isNotEmpty
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ReUseAbleText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .options,
                                                  style: appstyle(
                                                      12,
                                                      Colors.black,
                                                      FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                SizedBox(
                                                  width: locale.languageCode ==
                                                          'ar'
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.75
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.70,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        meal.options?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (!options.contains(
                                                              meal.options?[
                                                                  index])) {
                                                            options.add(
                                                                meal.options?[
                                                                    index]);
                                                          } else {
                                                            options.remove(
                                                                meal.options?[
                                                                    index]);
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5.w),
                                                          decoration: BoxDecoration(
                                                              color: options.contains(
                                                                      meal.options?[
                                                                          index])
                                                                  ? Colors.grey
                                                                      .shade200
                                                                  : Colors
                                                                      .transparent,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black38,
                                                                  width: 0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  ReUseAbleText(
                                                                text:
                                                                    meal.options?[
                                                                        index],
                                                                style: appstyle(
                                                                    12,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  const Divider(
                                    indent: 10,
                                    endIndent: 10,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          meal.title,
                                          style: appstyle(16, Colors.black,
                                              FontWeight.w700),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        meal.description,
                                        textAlign: TextAlign.justify,
                                        maxLines: 4,
                                        style: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 12.h),
                                        child: Center(
                                          child: CheckOutButton(
                                            onTap: () {
                                              cartNotifier.createCart({
                                                "id": meal.id,
                                                "name": meal.name,
                                                "title": meal.title,
                                                "category": meal.category,
                                                "imageUrl": meal.imageUrl,
                                                "price": meal.price,
                                                "options": options,
                                                "components": meal.components,
                                                "description": meal.description,
                                                "qty": qty
                                              });
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext dContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .mealAdded,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    content: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .mealAddedBody,
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .searchForMore,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(dContext)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MainScreen()),
                                                          );
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .goToOrderList,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        onPressed: () {
                                                          mainScreenNotifier
                                                              .pageIndex = 3;
                                                          Navigator.of(dContext)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const MainScreen()),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            label: AppLocalizations.of(context)!
                                                .addToOrder,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
        );
      },
    ));
  }
}
