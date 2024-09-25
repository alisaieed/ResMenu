import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:ecommerce_app/Controllers/orders_provider.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Models/order_model.dart';
import '../Shared/appstyle.dart';
import '../Shared/reuseableText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status; // Initialize selectedStatus here
  }

  @override
  Widget build(BuildContext context) {
    List<String> statusList = [
      AppLocalizations.of(context)!.orderNew,
      AppLocalizations.of(context)!.cooking,
      AppLocalizations.of(context)!.doneCooking,
      AppLocalizations.of(context)!.done
    ];

    var orderProvider = Provider.of<OrdersProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: Padding(
          padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0493,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      orderProvider.getAllOrders();
                    },
                    child: const Icon(Icons.arrow_back),
                  )),
              Row(
                children: [
                  ReUseAbleText(
                    text: AppLocalizations.of(context)!
                        .orderDetails(widget.order.id),
                    style: appstyle(20, Colors.black, FontWeight.bold),
                  ),
                  ReUseAbleText(
                    text: widget.order.clientName,
                    style: appstyle(20, Colors.grey, FontWeight.bold),
                  ),
                ],
              ),
              Flexible(
                child: SizedBox(
                  child: ListView.builder(
                      itemCount: widget.order.meals.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        var data = widget.order.meals[index];
                        return Padding(
                          padding: EdgeInsets.all(8.h),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.13,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade500,
                                        spreadRadius: 5,
                                        blurRadius: 0.3,
                                        offset: const Offset(0, 1)),
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.h),
                                            child: CachedNetworkImage(
                                              imageUrl: data['imageUrl'][0],
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.187,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0863,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ReUseAbleText(
                                              text: data['name'],
                                              style: appstyle(16, Colors.black,
                                                  FontWeight.bold),
                                            ),
                                            ReUseAbleText(
                                              text: data['category'],
                                              style: appstyle(14, Colors.grey,
                                                  FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  ReUseAbleText(
                                                    text: data['price'],
                                                    style: appstyle(
                                                        12,
                                                        Colors.black,
                                                        FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  data['options'].toString() !=
                                                          "[]"
                                                      ? ReUseAbleText(
                                                          text: data['options']
                                                              .join("\n")
                                                              .toString(),
                                                          style: appstyle(
                                                              12,
                                                              Colors.black,
                                                              FontWeight.w600),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.h),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Column(
                children: [
                  widget.order.note.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.all(8.0.h),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.clientNote,
                                style:
                                    appstyle(16, Colors.black, FontWeight.w500),
                              ),
                              Text(
                                "   ${widget.order.note}",
                                style: appstyle(
                                    14, Colors.black, FontWeight.normal),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 3.0 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ReUseAbleText(
                          text: AppLocalizations.of(context)!.orderStatus,
                          style: appstyle(16, Colors.black, FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.72,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: statusList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  selectedStatus = statusList[index];

                                  final DocumentReference docRef =
                                      FirebaseFirestore.instance
                                          .collection("Orders")
                                          .doc(widget.order.id.toString());
                                  await docRef.update({'status': selectedStatus});

                                  setState(() {

                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                      color: selectedStatus == statusList[index]
                                          ? Colors.white
                                          : Colors.transparent,
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ReUseAbleText(
                                        text: statusList[index],
                                        style: appstyle(
                                            12, Colors.black, FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
