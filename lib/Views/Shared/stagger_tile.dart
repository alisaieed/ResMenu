import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/Shared/reuseableText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaggerTile extends StatefulWidget {
  const StaggerTile({super.key, required this.imageUrl, required this.name, required this.price, required this.components});

  final String imageUrl;
  final String name;
  final String price;
  final String components;

  @override
  State<StaggerTile> createState() => _StaggerTileState();
}

class _StaggerTileState extends State<StaggerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
      color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
      child: Padding(
        padding:  EdgeInsets.all(8.h),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height*0.22,
                  imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.h,),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReUseAbleText(
                      text: widget.name,
                  style: appstyleWithHt(
                      18, Colors.black, FontWeight.w700,1)
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ReUseAbleText(
                      text: widget.components,
                      style: appstyleWithHt(
                          12, Colors.black, FontWeight.w200,1)
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: 6.h),
                    child: ReUseAbleText(
                        text: widget.price,
                        style: appstyleWithHt(
                            14, Colors.black, FontWeight.w500,1)
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
