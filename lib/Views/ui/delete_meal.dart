import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controllers/meals_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteMealPage extends StatefulWidget {
  const DeleteMealPage({super.key});

  @override
  State<DeleteMealPage> createState() => _DeleteMealPageState();
}

class _DeleteMealPageState extends State<DeleteMealPage> {

  late String selectedCategory;

  @override
  Widget build(BuildContext context) {
    TextEditingController _mealIdController = TextEditingController();
    var mealsNotifier = Provider.of<MealNotifier>(context);
    FireStoreHelper fireStoreHelper = FireStoreHelper();

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),
        title: Text(AppLocalizations.of(context)!.deleteMeal),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.enterMealIDforDelete,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _mealIdController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.mealID,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: mealsNotifier.categoriesList[0],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.category,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              iconSize: 25,
              dropdownColor: Colors.grey.shade300,
              items: mealsNotifier.categoriesList.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value!;
                  print(selectedCategory);
                });
              },
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  backgroundColor: Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  print(selectedCategory);
                  String mealId = _mealIdController.text;
                  if (_mealIdController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.missingInformation,
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            AppLocalizations.of(context)!.informationFill,
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.ok),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    try {
                      fireStoreHelper.deleteMeal(selectedCategory, mealId, context);
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text(
                              AppLocalizations.of(context)!.success,
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                                AppLocalizations.of(context)!.mealDeleted),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.ok),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      print('Error deleting document: $e');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.error),
                            content: Text(
                                AppLocalizations.of(context)!.mealNotDeleted),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.ok),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text(AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
