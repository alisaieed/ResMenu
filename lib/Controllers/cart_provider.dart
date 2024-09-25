
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {

  final _cartBox = Hive.box('cart_box');
  List<dynamic> _cart = [];

  List<dynamic> get cart => _cart;
  set cart (List<dynamic> newCart) {
    _cart = newCart;
    notifyListeners();
  }

  getCart(){
    final cartData = _cartBox.keys.map((key) {
      final item = _cartBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "title": item['title'],
        "category": item['category'],
        "name": item['name'],
        "options": item['options'],
        "imageUrl": item['imageUrl'],
        "price": item['price'],
        "qty": item['qty'],
        "components": item['components'],
        "description": item['description']
      };
    }).toList();

    _cart = cartData.reversed.toList();
  }

  Future<void> createCart(Map<dynamic, dynamic> newCart) async {
    await _cartBox.add(newCart);
    notifyListeners();
  }

  clearCart(String cart) async{
    _cartBox.clear();
  }

  deleteCart(int key) async {
    await _cartBox.delete(key);
    notifyListeners();
  }

  Future<void> updateQty(int key, int newQty) async {
    final item = _cartBox.get(key);
    if (item != null) {
      item['qty'] = newQty;
      await _cartBox.put(key, item);
      notifyListeners();
    }
  }

}