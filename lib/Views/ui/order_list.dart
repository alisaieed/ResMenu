import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Controllers/cart_provider.dart';
import 'package:ecommerce_app/Controllers/orders_provider.dart';
import 'package:ecommerce_app/Models/meal_model.dart';
import 'package:ecommerce_app/Views/Shared/appstyle.dart';
import 'package:ecommerce_app/Views/Shared/check_out.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../Models/order_model.dart';
import '../Shared/reuseableText.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCart();

    var rng = Random();
    var orderID = rng.nextInt(1000) + 1;


    var orderProvider = Provider.of<OrdersProvider>(context);
    TextEditingController tableController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    List<Meals> meals = [];
    double totalAmount = 0.0;


    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFE2E2E2),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0.0.w),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 8.w),
                            child: ReUseAbleText(
                              text: AppLocalizations.of(context)!.myOrder,
                              style: appstyle(25, Colors.black, FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                            child: GestureDetector(
                              onTap: () {
                                cartProvider.clearCart("cart_box");
                                setState(() {

                                });
                              },
                              child:  Text(AppLocalizations.of(context)!.clearAll),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 8.0.w, bottom: 8.0.w),
                      child: Container(
                        height: 1.h,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.55,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                          itemCount: cartProvider.cart.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final data = cartProvider.cart[index];
                            totalAmount =
                                totalAmount + double.parse(data['price']);
                            Meals newMeal = Meals(
                              id: data['id'],
                              name: data['name'],
                              qty: data['qty'],
                              options: data['options'],
                              components: data['components'],
                              imageUrl: data['imageUrl'],
                              price: data['price'],
                              category: data['category'],
                              description: data['description'],
                              title: data['title'],
                            );
                            meals.add(newMeal);
                            return Padding(
                              padding: EdgeInsets.all(8.h),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: Slidable(
                                  key: const ValueKey(0),
                                  endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 1,
                                          onPressed: (_) => cartProvider
                                              .deleteCart(data['key']),
                                          backgroundColor:
                                              const Color(0xFF000000),
                                          foregroundColor: Colors.white,
                                          icon: Icons.close,
                                          label: 'Delete',
                                        ),
                                      ]),
                                  child: Container(
                                    // height: 170.56.h,
                                    // width: 375.w,
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
                                                    imageUrl:
                                                        "${data['imageUrl'][0]}",
                                                    width: MediaQuery.of(context).size.width*0.187,
                                                    height: MediaQuery.of(context).size.height*0.089,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -2.h,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      cartProvider.deleteCart(
                                                          data['key']);
                                                      // Navigator.pushReplacement(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             const MainScreen()));
                                                    },
                                                    child: Container(
                                                      width: 35.w,
                                                      height: 25.h,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        12)),
                                                      ),
                                                      child: const Icon(
                                                        Ionicons.remove,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
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
                                                    style: appstyle(
                                                        14,
                                                        Colors.black,
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  ReUseAbleText(
                                                    text: data['category'],
                                                    style: appstyle(
                                                        12,
                                                        Colors.grey,
                                                        FontWeight.w600),
                                                  ),
                                                  data['options']
                                                              .toString() !=
                                                          "[]"
                                                      ? Text(
                                                              data['options'].join('\n')
                                                                  .toString(),
                                                          style: appstyle(
                                                              10,
                                                              Colors.black,
                                                              FontWeight
                                                                  .w600),
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                        )
                                                      : const SizedBox(),
                                                  ReUseAbleText(
                                                    text: "\$${data['price']}",
                                                    style: appstyle(
                                                        12,
                                                        Colors.black,
                                                        FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    cartProvider.updateQty(
                                                        data['key'],
                                                        data['qty'] + 1);
                                                  },
                                                  child: const Icon(
                                                    Icons.add_box,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  data['qty'].toString(),
                                                  style: appstyle(
                                                      12,
                                                      Colors.black,
                                                      FontWeight.w600),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (data['qty'] > 1) {
                                                      cartProvider.updateQty(
                                                          data['key'],
                                                          data['qty'] - 1);
                                                    }
                                                  },
                                                  child: data['qty'] > 1
                                                      ? const Icon(
                                                          Icons
                                                              .indeterminate_check_box,
                                                          size: 20,
                                                          color: Colors.black,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .indeterminate_check_box,
                                                          size: 20,
                                                          color: Colors.grey,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2E2E2),
                      ),
                      padding: EdgeInsets.only(left: 8.0.w),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10.w), topLeft:  Radius.circular(10.w))
                            ),
                            height: MediaQuery.of(context).size.height*0.062,
                            width: MediaQuery.of(context).size.width*0.667,
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 12.h
                                ),
                                contentPadding: EdgeInsets.all(8.0.h),
                                border: const OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.clientName,

                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.061,
                            width: MediaQuery.of(context).size.width*0.267,
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: TextField(
                              controller: tableController,
                              decoration:  InputDecoration(
                                labelStyle: TextStyle(
                                  fontSize: 12.h
                                ),
                                contentPadding: EdgeInsets.all(8.0.h),
                                border: const OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.tableNO,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFE2E2E2),
                      ),
                      padding: EdgeInsets.only(left: 8.0.w, bottom: 10.0.h),
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.95,
                        padding:  EdgeInsets.only(top: 10.h),
                        child: TextField(
                          controller: noteController,
                          decoration:  InputDecoration(
                            labelStyle: TextStyle(
                              fontSize: 12.h
                            ),
                            contentPadding: EdgeInsets.all(8.0.h),
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.leaveNote,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2E2E2),
                      ),
                      child: CheckOutButton(
                          onTap: () {
                            if (tableController.text.isEmpty ||
                                nameController.text.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext dContext) {
                                    return AlertDialog(
                                      content:  Text(
                                          AppLocalizations.of(context)!.noNameID),
                                      contentPadding: const EdgeInsets.all(12),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(dContext);
                                            },
                                            child:  Text(
                                              AppLocalizations.of(context)!.ok,
                                              style: const TextStyle(color: Colors.black),
                                            ))
                                      ],
                                    );
                                  });
                            } else {
                              Map<String, dynamic> orderMap = {
                                'id' : orderID,
                                'tableNumber': tableController.text,
                                'meals': meals,
                                'totalAmount': totalAmount,
                                'note': noteController.text,
                                'clientName': nameController.text,
                                'status': AppLocalizations.of(context)!.orderNew
                              };

                              Order order = Order.fromJson(orderMap);

                              orderProvider.addNewOrder(order, orderID.toString());

                              showDialog(
                                  context: context,
                                  builder: (BuildContext dContext) {
                                    return AlertDialog(
                                      content:  Text(
                                          AppLocalizations.of(context)!.orderAdded(orderID)),
                                      contentPadding:
                                      const EdgeInsets.all(12),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(dContext);
                                            },
                                            child:  Text(
                                              AppLocalizations.of(context)!.close,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ))
                                      ],
                                    );
                                  });
                            }
                          },
                          label: AppLocalizations.of(context)!.confirmOrder),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
