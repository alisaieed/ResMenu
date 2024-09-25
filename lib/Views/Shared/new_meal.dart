import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Views/Shared/reuseableText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appstyle.dart';

class NewMeal extends StatelessWidget {
  const NewMeal({
    super.key, required this.imageUrl, required this.name,
  });
final String imageUrl;
final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(16.h)),
          boxShadow: const [
            BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 0.8,
                offset: Offset(0, 1)),
          ]),
      height: MediaQuery.of(context).size.height*0.12,
      width: MediaQuery.of(context).size.width*0.24,
      child: Column(

        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.09,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(16.h)),
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image:  CachedNetworkImageProvider(imageUrl)
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1.5),
            child: ReUseAbleText(
              text: name,
              style: appstyle(10, Colors.black, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}