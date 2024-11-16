
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controllers/meals_provider.dart';

class DeleteCategoryPage extends StatefulWidget {
  const DeleteCategoryPage({super.key});

  @override
  State<DeleteCategoryPage> createState() => _DeleteCategoryPageState();
}

class _DeleteCategoryPageState extends State<DeleteCategoryPage> {

  String category = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FireStoreHelper fireStoreHelper = FireStoreHelper();
    fireStoreHelper.getAllCategories(context);

    var mealsNotifier = Provider.of<MealNotifier>(context, listen: false);
    category =  mealsNotifier.categoriesList[0];
  }

  TextEditingController _categoryNameController = TextEditingController();
  FireStoreHelper fireStoreHelper = FireStoreHelper();
  @override
  Widget build(BuildContext context) {

    var mealsProvider = Provider.of<MealNotifier>(context, listen: false);
    var mealsNotifier = Provider.of<MealNotifier>(context, listen: false);

    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE2E2E2),

          title: const Text('Delete Category'),
        ),
        body:
        _isLoading ? CircularProgressIndicator() : Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please select the category to delete'),
              const SizedBox(height: 16.0), // Add spacing
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
              const SizedBox(height: 16.0), // Add spacing
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await fireStoreHelper.deleteCategory(context, category);
                  mealsNotifier.getCategories(context);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        )
    );
  }
}
