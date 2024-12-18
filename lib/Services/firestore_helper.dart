import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:ecommerce_app/Views/ui/edit_meal.dart';
import 'package:ecommerce_app/Views/ui/settings_page.dart';
import 'package:flutter/material.dart';
import '../Controllers/firebase_messaging.dart';
import '../Models/meal_model.dart';
import '../Models/order_model.dart';
import '../Views/ui/add_meal.dart';

class FireStoreHelper {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Orders');

  Future<Map<String, dynamic>?> getMealData(
      String category, String docID, Locale locale) async {
    if (locale.languageCode == 'en') {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Meals_en')
            .doc(category)
            .collection('Meals')
            .doc(docID)
            .get();

        if (documentSnapshot.exists) {
          return documentSnapshot.data() as Map<String, dynamic>;
        } else {
          print('Document does not exist');
          return null;
        }
      } catch (e) {
        print('Error fetching document data: $e');
        return null;
      }
    } else {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Meals_ar')
            .doc(category)
            .collection('Meals')
            .doc(docID)
            .get();

        if (documentSnapshot.exists) {
          return documentSnapshot.data() as Map<String, dynamic>;
        } else {
          print('Document does not exist');
          return null;
        }
      } catch (e) {
        print('Error fetching document data: $e');
        return null;
      }
    }
  }

  Future<void> deleteCategory(BuildContext context, String category) async {
    Locale locale = Localizations.localeOf(context);
    if(locale.languageCode == 'en'){
      await FirebaseFirestore.instance
          .collection('Meals_en')
          .doc(category)
          .delete();
    }else {
      await FirebaseFirestore.instance
          .collection('Meals_ar')
          .doc(category)
          .delete();
    }
  }

  Future<void> addCategoryWithMealsCollection(
      BuildContext context, String category) async {
    Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      await FirebaseFirestore.instance
          .collection('Meals_en')
          .doc(category)
          .set({});
    } else {
      await FirebaseFirestore.instance
          .collection('Meals_ar')
          .doc(category)
          .set({});
    }
  }

  Future<void> deleteMeal(
      String category, String docID, BuildContext context) async {
    Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'en') {
      await FirebaseFirestore.instance
          .collection('Meals_en')
          .doc(category)
          .collection('Meals')
          .doc(docID)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('Meals_ar')
          .doc(category)
          .collection('Meals')
          .doc(docID)
          .delete();
    }
  }

  Future<List<Order>> getOrders() async {
    QuerySnapshot querySnapshot =
        await orderCollection.orderBy('timestamp', descending: false).get();
    return querySnapshot.docs
        .map((doc) => Order.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrder(String docId, Order order) async {
    return orderCollection.doc(docId).set({
      ...order.toJson(),
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      sendMessageTopic("New Order", "A new order has been added", "orders");
    }).catchError((error) => print("Failed to add order: $error"));
  }

  Future<void> deleteOrder(String docId) async {
    return orderCollection.doc(docId).delete().then((_) {
      print("Order Deleted");
    }).catchError((error) => print("Failed to delete order: $error"));
  }

  Future<void> editMeal(
    BuildContext context,
    String langCode,
    String category,
    String mealId,
    String name,
    String title,
    String description,
    List<String> imageUrl,
    List<String> options,
    List<String> components,
    String price,
  ) async {
    if (langCode == "en") {
      await fireStore
          .collection('Meals_en')
          .doc(category)
          .collection('Meals')
          .doc(mealId)
          .set({
        'name': name,
        'id': mealId,
        'title': title,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'options': options,
        'components': components,
        'price': price,
      });
    } else {
      await fireStore
          .collection('Meals_ar')
          .doc(category)
          .collection('Meals')
          .doc(mealId)
          .set({
        'name': name,
        'id': mealId,
        'title': title,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'options': options,
        'components': components,
        'price': price,
      });
    }
  }

  Future<void> addMeal(
    BuildContext context,
    String langCode,
    String category,
    String mealId,
    String name,
    String title,
    String description,
    List<String> imageUrl,
    List<String> options,
    List<String> components,
    String price,
  ) async {
    if (langCode == "en") {
      await fireStore
          .collection('Meals_en')
          .doc(category)
          .collection('Meals')
          .doc(mealId)
          .set({
        'name': name,
        'id': mealId,
        'title': title,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'options': options,
        'components': components,
        'price': price,
      });
    } else {
      await fireStore
          .collection('Meals_ar')
          .doc(category)
          .collection('Meals')
          .doc(mealId)
          .set({
        'name': name,
        'id': mealId,
        'title': title,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'options': options,
        'components': components,
        'price': price,
      });
    }
  }

  Future<Meals> getMealByID(String category, String mealId) async {
    DocumentSnapshot doc =
        await fireStore.collection(category).doc(mealId).get();
    return Meals.fromJson(doc.data() as Map<dynamic, dynamic>);
  }

  Future<List<Meals>> getMealsByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await fireStore.collection(category).get();
      List<Meals> meals = querySnapshot.docs.map((doc) {
        return Meals.fromJson(doc.data() as Map<dynamic, dynamic>);
      }).toList();
      print("Fetched ${meals.length} meals from category $category");
      return meals;
    } catch (e) {
      print("Error getting meals by category: $e");
      return [];
    }
  }

  Future<List<Meals>> getLastAdded(
      BuildContext context, String collection) async {
    QuerySnapshot querySnapshot = await fireStore.collection(collection).get();
    return querySnapshot.docs.map((doc) {
      return Meals.fromJson(doc.data() as Map<dynamic, dynamic>);
    }).toList();
  }

  Future<List<String>> getAllCategories(BuildContext context) async {
    try {
      List<String> categories = [];
      QuerySnapshot querySnapshot;

      if (Localizations.localeOf(context).languageCode == 'ar') {
        querySnapshot =
            await FirebaseFirestore.instance.collection('Meals_ar').get();
      } else {
        querySnapshot =
            await FirebaseFirestore.instance.collection('Meals_en').get();
      }

      for (var doc in querySnapshot.docs) {
        categories.add(doc.id);
      }

      return categories;
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<Meals>> getAllMeals(
      BuildContext context, List<String> categories) async {
    List<Meals> mealList = [];
    if (Localizations.localeOf(context).languageCode == 'ar') {
      try {
        for (var category in categories) {
          QuerySnapshot querySnapshot = await fireStore
              .collection("Meals_ar")
              .doc(category)
              .collection("Meals")
              .get();
          var categoryMeals = querySnapshot.docs.map((doc) {
            return Meals.fromJson(doc.data() as Map<dynamic, dynamic>);
          }).toList();
          mealList
              .addAll(categoryMeals); // Add meals of this category to the list
        }
        return mealList;
      } catch (e) {
        print("Error getting meals by category: $e");
        return [];
      }
    } else {
      try {
        for (var category in categories) {
          QuerySnapshot querySnapshot = await fireStore
              .collection("Meals_en")
              .doc(category)
              .collection("Meals")
              .get();
          var categoryMeals = querySnapshot.docs.map((doc) {
            return Meals.fromJson(doc.data() as Map<dynamic, dynamic>);
          }).toList();
          mealList
              .addAll(categoryMeals); // Add meals of this category to the list
        }
        return mealList;
      } catch (e) {
        print("Error getting meals by category: $e");
        return [];
      }
    }
  }
}
