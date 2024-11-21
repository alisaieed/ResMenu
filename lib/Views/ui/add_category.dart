import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:ecommerce_app/Views/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context)!.addCategory),
        ),
        body: _isLoading
            ? const CircularProgressIndicator()
            : Container(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.enterCategoryName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                    SizedBox(height: MediaQuery.of(context).size.height*0.05),
                    TextFormField(
                      controller:
                          _categoryNameController,
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
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.018),
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
                          if (_categoryNameController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return Center(
                                  child: AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .missingInformation,
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                      AppLocalizations.of(context)!
                                          .informationFill,
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            String newCategoryName =
                                _categoryNameController.text;
                            try {
                              await fireStoreHelper
                                  .addCategoryWithMealsCollection(
                                      context, newCategoryName);
                              mealsProvider.getCategories(context);
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)!.success),
                                    content: Text(AppLocalizations.of(context)!
                                        .categoryAdded),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();

                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      const SettingsPage()));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)!.error),
                                    content: Text(
                                        '${AppLocalizations.of(context)!.categoryNotAdded}: $e'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.submit,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
