import 'package:ecommerce_app/Views/ui/add_category.dart';
import 'package:ecommerce_app/Views/ui/add_meal.dart';
import 'package:ecommerce_app/Views/ui/delete_category.dart';
import 'package:ecommerce_app/Views/ui/delete_meal.dart';
import 'package:ecommerce_app/Views/ui/editRestaurant.dart';
import 'package:ecommerce_app/Views/ui/edit_meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  List<String> settingsOptions=[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        settingsOptions = [
          AppLocalizations.of(context)!.addMeal,
          AppLocalizations.of(context)!.editMeal,
          AppLocalizations.of(context)!.deleteMeal,
          AppLocalizations.of(context)!.addCategory,
          AppLocalizations.of(context)!.deleteCategory,
          AppLocalizations.of(context)!.editRestaurant,
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),
        title: Center(
          child: Text(AppLocalizations.of(context)!.dashboard,
              style: const TextStyle(color: Colors.black, fontSize: 28)),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView.builder(
          itemCount: settingsOptions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: Colors.grey.shade100,
                    elevation: 1, // Shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMealPage()));
                    } else if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditMealPage()));
                    } else if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteMealPage()));
                    } else if (index == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCategoryPage()));
                    } else if (index == 4) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteCategoryPage()));
                    } else if (index == 5) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditRestaurantPage()));
                    }
                  },
                  child: Text(
                    settingsOptions[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
