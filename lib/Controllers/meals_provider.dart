import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/meal_model.dart';
import '../Services/firestore_helper.dart';

class MealNotifier extends ChangeNotifier{
  int _activePage = 0;

  List<String> _options = [];

  List<String> get options => _options;

  int get activePage => _activePage;

  set activePage(int newIndex){
    _activePage = newIndex;
    notifyListeners();
  }

  late Future<List<Meals>> allMeals;
  late Future<List<Meals>> lastAddedMeals;
  late Future<List<String>> categories;
  late Meals meal;
  List<Meals> allMealsList = [];
  List<String> categoriesList = [];
  late Future<int> categoriesLength ;

  Future<void> getCategories(BuildContext context) async{

    categories = FireStoreHelper().getAllCategories(context);
    categoriesList = await categories;
    print(categoriesList);

  }

  Future<List<Meals>> getAllMeals(BuildContext context) async {
    await getCategories(context);
    allMeals =  FireStoreHelper().getAllMeals(context, categoriesList);
    allMealsList = await allMeals;
    return allMealsList;
  }

  void getMeals(String category, String id){
    meal = allMealsList.firstWhere((obj) => obj.id == id && obj.category == category);
  }


  void getLastAddedMeals(BuildContext context){
    if (Localizations.localeOf(context).languageCode == 'ar'){
      lastAddedMeals = FireStoreHelper().getLastAdded(context, "newAddedMeals_ar");
    }else {
      lastAddedMeals =  FireStoreHelper().getLastAdded(context, "newAddedMeals");
    }
  }


}
