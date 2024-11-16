import 'package:ecommerce_app/Views/ui/add_category.dart';
import 'package:ecommerce_app/Views/ui/add_meal.dart';
import 'package:ecommerce_app/Views/ui/delete_category.dart';
import 'package:ecommerce_app/Views/ui/delete_meal.dart';
import 'package:ecommerce_app/Views/ui/edit_meal.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  List<String> settingsOptions = ['Add Meal', 'Add Category','Delete Meal','Delete Category', 'Edit Meal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),
        title: const Center(child: Text('Dashboard')),
      ),
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width*0.25,
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(Colors.white38),
                backgroundColor: WidgetStateProperty.all(Colors.white38)
              ),
              onPressed: () {
                if (index == 0){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddMealPage(),));
                }
                else if (index == 1){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => AddCategoryPage(),));
                }
                else if (index == 2){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DeleteMealPage(),));
                }
                else if (index == 3){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DeleteCategoryPage(),));
                }
                else if (index == 4){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => EditMealPage(),));
                }
              },
              child: Text(settingsOptions[index],
              style: const TextStyle(
                color: Colors.black
              ),),
            ),
          );
        },
      ),
    );
  }
}
