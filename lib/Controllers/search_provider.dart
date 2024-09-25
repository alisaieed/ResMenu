import 'package:ant_design_flutter/ant_design_flutter.dart';
import '../Models/meal_model.dart';


class SearchNotifier extends ChangeNotifier{

Future<List<Meals>> searchItem(String text, List<Meals> allMeals) async {
  List<Meals> searchResult = [];
  text.toLowerCase();
  for (int i = 0; i < allMeals.length; i++) {
    if (allMeals[i].id.toLowerCase().contains(text)) {
      searchResult.add(allMeals[i]);
    } else if (allMeals[i].name.toLowerCase().contains(text)) {
      searchResult.add(allMeals[i]);
    } else if (allMeals[i].category.toLowerCase().contains(text)) {
      searchResult.add(allMeals[i]);
    }
  }
  notifyListeners();
  return searchResult;
}

}
