import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ecommerce_app/Services/firestore_helper.dart';

import '../Models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  late final Order orderToPost;
  late Future<List<Order>> orders;

  Future<bool> deleteOrder(Order order) async {
    await FireStoreHelper().deleteOrder(order.id.toString());
    // Helper().deleteOrderOnline(order);
    getAllOrders();
    return true;
  }

  void getAllOrdersInit() async {
    orders = FireStoreHelper().getOrders();
  }

  void getAllOrders() async {
    // orders =  Helper().getOrdersOnline();
    orders = FireStoreHelper().getOrders();
    notifyListeners();
  }

  void addNewOrder(Order order, String orderID) async {
    // await Helper().addOrderOnline(order);
    await FireStoreHelper().addOrder(orderID, order);
    getAllOrders();
  }
}
