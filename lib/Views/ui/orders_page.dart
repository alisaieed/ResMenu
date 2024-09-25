
import 'package:ecommerce_app/Controllers/mainscreen_provider.dart';
import 'package:ecommerce_app/Controllers/orders_provider.dart';
import 'package:ecommerce_app/Views/ui/order_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../Models/order_model.dart';
import '../Shared/appstyle.dart';
import '../Shared/reuseableText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  late List<Order> ordersList;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic("orders");
      var ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getAllOrdersInit();
  }

  @override
  Widget build(BuildContext context) {

    var mainScreenNotifier = Provider.of<MainScreenNotifier>(context);

    var ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),

      body: SizedBox(
        height: MediaQuery.of(context).size.height*0.986,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.29,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:WidgetStateProperty.all<Color>(Colors.grey.shade200)
                      ),
                      onPressed:(){
                        ordersProvider.getAllOrders();
                      } ,
                      child:  ReUseAbleText(text: AppLocalizations.of(context)!.getOrders,
                          style: appstyle(16, Colors.black, FontWeight.bold))
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.214,
                  ),
                  GestureDetector(
                      onTap: () async {await FirebaseAuth.instance.signOut();
                      FirebaseMessaging.instance.unsubscribeFromTopic("orders");
                      mainScreenNotifier.pageIndex = 0;
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.exit_to_app, color: Colors.black,),
                      )
                  ),
                ],
              )
            ),
            FutureBuilder<List<Order>>(
              future: ordersProvider.orders, // the Future you want to work with
              builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.black,)); // show a loading spinner while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // show error message if any error occurred
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.863,
                          child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index){
                                var data = snapshot.data?[snapshot.data!.length -1- index];
                                return Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                                  child: GestureDetector(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(order: data)));
                                    } ,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                      child: Slidable(
                                        key: const ValueKey(0),
                                        endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                flex: 1,
                                                onPressed: (_) => ordersProvider.deleteOrder(data!),
                                                backgroundColor: const Color(0xFF000000),
                                                foregroundColor: Colors.white,
                                                icon: Icons.close,
                                                label: AppLocalizations.of(context)!.delete,
                                              ),

                                            ]
                                        ),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*0.13,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade500,
                                                    spreadRadius: 5,
                                                    blurRadius: 0.3,
                                                    offset: const Offset(0,1)
                                                ),
                                              ]
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.all(8.h),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.094,
                                                          child: ReUseAbleText(
                                                            text: data!.tableNumber,
                                                            style: appstyle(20, Colors.black, FontWeight.bold),),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Container(
                                                          height: MediaQuery.of(context).size.height*0.0616,
                                                          width: 1.0.w,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          width: 20.w,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.4534,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ReUseAbleText(
                                                                text: "${AppLocalizations.of(context)!.client}: ${data.clientName}",
                                                                style: appstyle(14, Colors.black, FontWeight.w600),),
                                                              ReUseAbleText(
                                                                text: "${AppLocalizations.of(context)!.items}: ${data.meals.length}",
                                                                style: appstyle(14, Colors.black, FontWeight.w600),),
                                                              ReUseAbleText(
                                                                text: data.status,
                                                                style: (data.status == "New" || data.status == "جديد")?
                                                                appstyle(14, Colors.red.shade300, FontWeight.w600)
                                                                : (data.status == "Cooking" || data.status == "قيد الطبخ")?
                                                                appstyle(14, Colors.deepOrangeAccent, FontWeight.w600)
                                                                    : (data.status == "Done Cooking" || data.status == "انتهى الطبخ")?
                                                                appstyle(14, Colors.orange.shade300, FontWeight.w600) :
                                                                appstyle(14, Colors.green.shade300, FontWeight.w600)
                                                                ,),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width*0.0934,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            ReUseAbleText(
                                                              text: "${data.id}",
                                                              style: appstyle(14, Colors.grey, FontWeight.w600),),
                                                            ReUseAbleText(
                                                              text: "\$${data.totalAmount}",
                                                              style: appstyle(14, Colors.grey, FontWeight.w600),),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        );
                    },
                  );
                }
              },
            ),

          ],
        ),
      ),

    );
  }
}
