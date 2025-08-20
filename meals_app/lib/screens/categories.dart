import 'package:flutter/material.dart';
import 'package:meals_animation/data/dummy_data.dart';
import 'package:meals_animation/models/category.dart';
import 'package:meals_animation/models/meal.dart';
import 'package:meals_animation/screens/meals.dart';
import 'package:meals_animation/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1, //default boundaries animation values
    );

    _animationController.forward(); //forwared -> start ,repeat,stop
  }

  @override
  void dispose() {
    _animationController
        .dispose(); //removed from the memory when the widget is removed

    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    //if we keep the meal then it is true otherwise false
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MealsScreen(
                  title: category.title,
                  meals: filteredMeals,
                ))); //Navigator.of(context).push()  --> same
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
          //builder function executed for every tick of animation
          padding: EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: [
            //alternative to map
            for (final category in availableCategories)
              CategoryGridItem(
                  onSelectCategory: () {
                    _selectCategory(context, category);
                  },
                  category: category)
          ]
          // itemBuilder: (context, index) {}
          ), //it is not rebuilt and reevaluted 60 times per second
      builder: (context, child) => SlideTransition(
        position:Tween(
            begin: Offset(0, 0.3),
            end: Offset(0, 0),

        ).animate(CurvedAnimation(parent:_animationController , curve: Curves.easeInOut )),
        
        // _animationController.drive(Tween(
        //   begin: Offset(0, 0.3), //x -> horizontal and y -> vertical
        //   end: Offset(0, 0),
        // )
        
        // ),
        child: child,
      ), //animation offset ->
      //animatable child is required in the drive to animate between the  two other boundaries  -> tween
      
      // Padding(
      //       padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //       child: child,
      //     )); //only padding widget is rebuilt and reevaluted that often
      // )
    );
  }
}

//animation is restarts if the widget is re-added to the screen
// init state is called when the widget is created
// with child widget is included  in the animation but not re build so performance is optimized
