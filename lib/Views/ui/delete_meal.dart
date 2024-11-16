import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controllers/meals_provider.dart';

class DeleteMealPage extends StatefulWidget {
  const DeleteMealPage({super.key});

  @override
  State<DeleteMealPage> createState() => _DeleteMealPageState();
}

class _DeleteMealPageState extends State<DeleteMealPage> {

  @override
  Widget build(BuildContext context) {

    TextEditingController _mealIdController = TextEditingController();
    var mealsNotifier = Provider.of<MealNotifier>(context);
    String category = mealsNotifier.categoriesList[0];
    FireStoreHelper fireStoreHelper = FireStoreHelper();

    return  Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),

        title: const Text('Delete Meal'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
                child: Text('Enter the meal ID to delete', style: TextStyle(fontSize: 20),)
            ),
            const SizedBox(height: 16.0), // Add some spacing
            TextFormField(
              controller: _mealIdController, // Controller for the text field
              decoration: const InputDecoration(
                labelText: 'Meal ID',
              ),
            ),
            DropdownButtonFormField<String>(
              value: mealsNotifier.categoriesList[0],
              decoration: const InputDecoration(labelText: 'Category'),
              items: mealsNotifier.categoriesList.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            const SizedBox(height: 16.0), // Add some spacing
            ElevatedButton(
              onPressed: () {
                String mealId = _mealIdController.text;
                fireStoreHelper.deleteMeal(category, mealId, context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
