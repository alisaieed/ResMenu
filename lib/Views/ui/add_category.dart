
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controllers/meals_provider.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {

  bool _isLoading = false;
  TextEditingController _categoryNameController = TextEditingController();
  FireStoreHelper fireStoreHelper = FireStoreHelper();
  @override
  Widget build(BuildContext context) {

    var mealsProvider = Provider.of<MealNotifier>(context, listen: false);

    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE2E2E2),

          title: const Text('Add New Category'),
        ),
        body: _isLoading? CircularProgressIndicator() : Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please enter the new category\'s name'),
              const SizedBox(height: 16.0), // Add spacing
              TextFormField(
                controller: _categoryNameController, // Controller for the text field
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
              ),
              const SizedBox(height: 16.0), // Add spacing
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  String newCategoryName = _categoryNameController.text;
                  await fireStoreHelper.addCategoryWithMealsCollection(context, newCategoryName);
                  mealsProvider.getCategories(context);
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
