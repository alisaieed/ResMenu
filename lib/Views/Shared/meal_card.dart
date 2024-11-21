import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Controllers/favorites_provider.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/Shared/reuseableText.dart';
import 'package:ecommerce_app/Views/ui/favorites.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MealCard extends StatefulWidget {
  const MealCard(
      {super.key,
      required this.price,
      required this.category,
      required this.id,
      required this.name,
      required this.image,
      required this.components});

  final String price;
  final String category;
  final String id;
  final String name;
  final String image;
  final List<dynamic> components;

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {


  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0.h, isTablet(context)?10:20.w, 0.h),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * (isTablet(context) ? 0.3 : 0.6),          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 0.6,
                offset: Offset(1, 1))
          ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.21,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: CachedNetworkImageProvider(
                              widget.image,
                            ))),
                  ),
                  Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Consumer<FavoritesNotifier>(
                        builder: (context, favoritesNotifier, child) {
                          return GestureDetector(
                            onTap: () {
                              if (
                              // favoritesNotifier.ids.contains(widget.id) &&
                                  favoritesNotifier.names
                                      .contains(widget.name)) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Favorites()));
                              } else {
                                setState(() {
                                  favoritesNotifier.createFav({
                                    "id": widget.id,
                                    "name": widget.name,
                                    "category": widget.category,
                                    "price": widget.price,
                                    "imageUrl": widget.image,
                                  });
                                });

                              }
                            },
                            child:
                            // favoritesNotifier.ids.contains(widget.id) &&
                                    favoritesNotifier.names
                                        .contains(widget.name)
                                ? const Icon(CupertinoIcons.heart_circle)
                                : const Icon(CupertinoIcons.heart),
                          );
                        },
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                    ReUseAbleText(
                        text: widget.name,
                        style: appstyleWithHt(
                            15, Colors.black, FontWeight.bold, 1)),
                    const SizedBox(
                      height: 5,
                    ),
                    ReUseAbleText(
                        text: widget.category,
                        style: appstyleWithHt(
                            8, Colors.grey, FontWeight.w600, 1.3)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: ReUseAbleText(
                          text: widget.components.join(", ").toString(),
                          style: appstyleWithHt(
                              isTablet(context)?6:12, Colors.grey, FontWeight.w500, 1.5)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.h),
                child: ReUseAbleText(
                  text: widget.price,
                  style: appstyle(14, Colors.black, FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
