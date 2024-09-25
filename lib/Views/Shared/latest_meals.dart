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

  @override
  Widget build(BuildContext context) {
    return  StaggeredGridView.countBuilder(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              crossAxisSpacing: 7,
              mainAxisSpacing: 5,
              itemCount: _category.length,
              scrollDirection: Axis.vertical,
              staggeredTileBuilder: (index) => StaggeredTile.extent(
                  (index % 2 ==0)? 1:1 , (index % 4 == 1 || index % 4 == 3)
                  ?MediaQuery.of(context).size.height*0.45
                  :MediaQuery.of(context).size.height*0.42),
              itemBuilder: (context, index) {
                final meal = _category[index];

                return  GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=>
                                MealPage(id: meal.id, category: meal.category)));
                  },
                  child: 
                  StaggerTile(
                      imageUrl: meal.imageUrl[0],
                      components: meal.components.join(', ').toString(),
                      name: meal.name,
                      price: "\$${meal.price}"),
                );
              }
          );
        }
      }