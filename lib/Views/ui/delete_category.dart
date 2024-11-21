
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:ecommerce_app/Views/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

          title: Text(AppLocalizations.of(context)!.deleteCategory),
        ),
        body:
        _isLoading ? const CircularProgressIndicator() : Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.selectCategoryDelete, style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w400),),
              const SizedBox(height: 16.0), // Add spacing
              DropdownButtonFormField<String>(
                value: mealsNotifier.categoriesList[0],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.category,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                iconSize: 25,
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
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try{
                      await fireStoreHelper.deleteCategory(context, category);
                      mealsNotifier.getCategories(context);
                      setState(() {
                        _isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.success,
                            textAlign: TextAlign.center,),
                            content: Text(
                                AppLocalizations.of(context)!.categoryDeleted(category),
                            textAlign: TextAlign.center,),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.ok),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                          const SettingsPage()));                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      // Show error dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.error),
                            content: Text(AppLocalizations.of(context)!.categoryNotDeleted),
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

                  },
                  child: Text(AppLocalizations.of(context)!.delete,
                      style: const TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        )
    );
  }
}
