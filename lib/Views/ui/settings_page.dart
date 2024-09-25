import 'package:ecommerce_app/Views/ui/add_meal.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

List<String> options = ["Add Category", "Add Meal", "Edit Meal",];

class _SettingsPageState extends State<SettingsPage> {

  List<String> settingsOptions = ['Add Meal', 'Add Category', 'Edit Meal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),
        title: Center(child: Text('Settings Page')),
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
