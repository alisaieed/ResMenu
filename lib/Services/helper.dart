import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:ecommerce_app/Models/meal_model.dart';
import 'package:flutter/services.dart' as the_bundle;
import 'package:http/http.dart' as http;

import '../Controllers/firebase_messaging.dart';
import '../Models/order_model.dart';

class Helper {

  Future<int> mealIdGenerate(String category, Locale langCode) async {
    if (langCode.toString() == 'en'){
      try {
        CollectionReference mealsCollection = FirebaseFirestore.instance
            .collection('Meals_en')
            .doc(category)
            .collection('Meals');

        QuerySnapshot snapshot = await mealsCollection.get();

        return snapshot.docs.length+1;
      } catch (e) {
        print("Error fetching document count: $e");
        return 0;
      }
    } else {
      try {
        CollectionReference mealsCollection = FirebaseFirestore.instance
            .collection('Meals_ar')
            .doc(category)
            .collection('Meals');

        // Get the documents in the 'Meals' collection
        QuerySnapshot snapshot = await mealsCollection.get();

        // Return the count of documents
        return snapshot.docs.length+1;
      } catch (e) {
        print("Error fetching document count: $e");
        return 0;
      }
    }
  }

  Future<List<Order>> getOrdersOnline() async {
    final response = await http.get(Uri.parse("https://api.jsonstorage.net/v1/json/364f3b43-bdf4-4f5b-ba0d-2b5f53556929/3aa36377-36a9-4cc1-b59e-f38bd3b39e5c"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      print("Orders get done");
      return json.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> deleteOrderOnline(Order order) async {
    final orders = await getOrdersOnline();
    for (int i = 0 ; i < orders.length; i++){
      if (orders[i].id == order.id) {
        orders.remove(orders[i]);
      }
    }
    final response = await http.put(
      Uri.parse("https://api.jsonstorage.net/v1/json/364f3b43-bdf4-4f5b-ba0d-2b5f53556929/3aa36377-36a9-4cc1-b59e-f38bd3b39e5c?apiKey=571ed32c-22cc-461e-80af-3fc719225e08"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orders.map((order) => order.toJson()).toList()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete order');
    }else {
      print("Order Deleted Successfully");
    }
  }

  Future<void> addOrderOnline(Order order) async {
    final orders = await getOrdersOnline();
    for (int i = 0 ; i < orders.length; i++){
      if (orders[i].id == order.id) {
        orders.remove(orders[i]);
      }
    }
    orders.add(order);

    final response = await http.put(
      Uri.parse("https://api.jsonstorage.net/v1/json/364f3b43-bdf4-4f5b-ba0d-2b5f53556929/3aa36377-36a9-4cc1-b59e-f38bd3b39e5c?apiKey=571ed32c-22cc-461e-80af-3fc719225e08"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orders.map((order) => order.toJson()).toList()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add order');
    }else {
      print("Order Added Successfully");
      sendMessageTopic("New Order", "A new order has been added", "orders");
      print(response.body);
    }
  }

  Future<List<Meals>> getAllMealsOnline() async {
    final eastResponse = await http
        .get(Uri.parse('https://static.staticsave.com/ecommerceapp/men.json'));
    final drinksResponse = await http.get(
        Uri.parse('https://static.staticsave.com/ecommerceapp/women.json'));
    final westResponse = await http
        .get(Uri.parse('https://static.staticsave.com/ecommerceapp/kids.json'));

    if (eastResponse.statusCode == 200 &&
        drinksResponse.statusCode == 200 &&
        westResponse.statusCode == 200) {
      final eastList = mealsFromJson(eastResponse.body);
      final drinksList = mealsFromJson(drinksResponse.body);
      final westList = mealsFromJson(westResponse.body);

      late List<Meals> allLists = [];
      allLists.addAll(eastList);
      allLists.addAll(drinksList);
      allLists.addAll(westList);

      return allLists;
    } else {
      throw Exception('Failed to load sneakers');
    }
  }

  Future<List<Meals>> getEastMealsOnline() async {
    final eastResponse = await http
        .get(Uri.parse('https://static.staticsave.com/ecommerceapp/men.json'));

    if (eastResponse.statusCode == 200) {
      final eastList = mealsFromJson(eastResponse.body);
      return eastList;
    } else {
      throw Exception('Faild to load sneakers');
    }
  }

  Future<List<Meals>> getDrinksOnline() async {
    final drinksResponse = await http.get(
        Uri.parse('https://static.staticsave.com/ecommerceapp/women.json'));

    if (drinksResponse.statusCode == 200) {
      final drinksList = mealsFromJson(drinksResponse.body);
      return drinksList;
    } else {
      throw Exception('Faild to load sneakers');
    }
  }

  Future<List<Meals>> getWestMealsOnline() async {
    final westResponse = await http
        .get(Uri.parse('https://static.staticsave.com/ecommerceapp/kids.json'));

    if (westResponse.statusCode == 200) {
      final westList = mealsFromJson(westResponse.body);
      return westList;
    } else {
      throw Exception('Failed to load sneakers');
    }
  }

  Future<Meals> getEastMealByIdOnline(String id) async {
    final eastResponse = await http
        .get(Uri.parse('https://static.staticsave.com/ecommerceapp/men.json'));

    if (eastResponse.statusCode == 200) {
      final eastList = mealsFromJson(eastResponse.body);
      final meal = eastList.firstWhere((meal) => meal.id == id);

      return meal;
    } else {
      throw Exception('Failed to load sneakers');
    }
  }

  Future<Meals> getDrinkByIdOnline(String id) async {
    final drinksResponse = await http.get(
        Uri.parse('https://static.staticsave.com/ecommerceapp/women.json'));

    if (drinksResponse.statusCode == 200) {
      final drinksList = mealsFromJson(drinksResponse.body);
      final drink = drinksList.firstWhere((drink) => drink.id == id);

      return drink;
    } else {
      throw Exception('Failed to load sneakers');
    }
  }

  Future<Meals> getWestMealByIdOnline(String id) async {
    final westResponse = await http
        .get(Uri.parse('https://static.staticsave.com/ecommerceapp/kids.json'));

    if (westResponse.statusCode == 200) {
      final westList = mealsFromJson(westResponse.body);
      final west = westList.firstWhere((west) => west.id == id);

      return west;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<Meals>> getAllMeals() async {
    final east = await the_bundle.rootBundle
        .loadString("android/assets/json/east_meals.json");
    final drinks = await the_bundle.rootBundle
        .loadString("android/assets/json/drinks.json");
    final west = await the_bundle.rootBundle
        .loadString("android/assets/json/western_meals.json");

    final eastList = mealsFromJson(east);
    final drinksList = mealsFromJson(drinks);
    final westList = mealsFromJson(west);

    late List<Meals> allLists = [];
    allLists.addAll(eastList);
    allLists.addAll(drinksList);
    allLists.addAll(westList);

    return allLists;
  }

  Future<List<Meals>> getEastMeals() async {
    final data = await the_bundle.rootBundle
        .loadString("android/assets/json/east_meals.json");

    final eastList = mealsFromJson(data);

    return eastList;
  }

  Future<List<Meals>> getDrinks() async {
    final data = await the_bundle.rootBundle
        .loadString("android/assets/json/drinks.json");

    final drinksList = mealsFromJson(data);

    return drinksList;
  }

  Future<List<Meals>> getWestMeals() async {
    final data = await the_bundle.rootBundle
        .loadString("android/assets/json/western_meals.json");

    final westList = mealsFromJson(data);

    return westList;
  }

  Future<Meals> getEastMealByID(String id) async {
    final data = await the_bundle.rootBundle
        .loadString("android/assets/json/east_meals.json");

    final eastList = mealsFromJson(data);
    final meal = eastList.firstWhere((meal) => meal.id == id);

    return meal;
  }

  Future<Meals> getDrinkByID(String id) async {
    final data = await the_bundle.rootBundle
        .loadString("android/assets/json/drinks.json");

    final drinksList = mealsFromJson(data);
    final meal = drinksList.firstWhere((meal) => meal.id == id);

    return meal;
  }

  Future<Meals> getWestMealByID(String id) async {
    final data = await the_bundle.rootBundle
        .loadString("android/assets/json/western_meals.json");

    final westMeals = mealsFromJson(data);
    final meal = westMeals.firstWhere((meal) => meal.id == id);

    return meal;
  }
}
