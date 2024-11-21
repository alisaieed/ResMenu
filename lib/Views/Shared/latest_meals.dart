import 'package:ecommerce_app/Views/Shared/stagger_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../Models/meal_model.dart';
import '../ui/meal_page.dart';

class LatestMeals extends StatelessWidget {
  const LatestMeals({
    super.key,
    required List<Meals> category,
  }) : _category = category;

  final List<Meals> _category;

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: isTablet(context) ? 3 : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 5,
      itemCount: _category.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final meal = _category[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealPage(
                  id: meal.id,
                  name: meal.name,
                  category: meal.category,
                ),
              ),
            );
          },
          child: StaggerTile(
            imageUrl: meal.imageUrl[0],
            components: meal.components.join(', ').toString(),
            name: meal.name,
            price: "\$${meal.price}",
          ),
        );
      },
    );
  }
}
