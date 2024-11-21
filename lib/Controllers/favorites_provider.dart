import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesNotifier extends ChangeNotifier {
  List<dynamic> _fav = [];
  final _favBox = Hive.box('fav_box');

  List<dynamic> _ids = [];
  List<dynamic> _names = [];
  List<dynamic> _favorites = [];

  // List<dynamic> get ids => _ids;
  List<dynamic> get names => _names;


  set ids(List<dynamic> newIds) {
    _ids = newIds;
    notifyListeners();
  }

  List<dynamic> get favorites => _favorites;

  set favorites(List<dynamic> newFav) {
    _favorites = newFav;
    notifyListeners();
  }

  List<dynamic> get fav => _fav;

  set fav(List<dynamic> newFav) {
    _fav = newFav;
    notifyListeners();
  }

  Future<void> deleteFav(int key) async {
    await _favBox.delete(key);
    notifyListeners();
  }

  getAllData() {
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "name": item['name'],
        "category": item['category'],
        "price": item['price'],
        "imageUrl": item['imageUrl'],
      };
    }).toList();

    _fav = favData.reversed.toList();
  }

  Future<void> createFav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
    getFavorites();
    // notifyListeners();
  }


  getFavorites() {
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);

      return {"key": key, "id": item['id'], "name":item['name']};
    }).toList();

    _favorites = favData.toList();
    _ids = _favorites.map((item) => item['id']).toList();
    _names = _favorites.map((item) => item['name']).toList();
  }
}
