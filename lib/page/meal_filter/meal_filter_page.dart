import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/data/repo/repository.dart';
import 'package:recipes_app/data/service/meal_service.dart';
import 'package:recipes_app/page/details/meal_details_page.dart';
import 'package:recipes_app/page/details/meal_details_viewmodel.dart';
import 'meal_filter_viewmodel.dart';
 
import 'package:dio/dio.dart';

class MealFilterPage extends StatefulWidget {
  @override
  _MealFilterPageState createState() => _MealFilterPageState();
}

class _MealFilterPageState extends State<MealFilterPage> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Provider.of<MealFilterViewModel>(context, listen: false).listMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<MealFilterViewModel>(
            builder: (context, viewModel, child) {
              return DropdownButton<String>(
                value: _selectedCategory,
                hint: Text('Select a category'),
                isExpanded: true,
                items: viewModel.mealCategories?.meals?.map((meal) {
                  return DropdownMenuItem<String>(
                    value: meal.strCategory,
                    child: Text(meal.strCategory ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                  if (value != null) {
                    viewModel.filterMeals(value);
                  }
                },
              );
            },
          ),
          SizedBox(height: 20),
          Consumer<MealFilterViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.errorMessage != null) {
                return Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Colors.red),
                );
              }
              if (viewModel.filterResults == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: viewModel.filterResults!.meals!.length,
                  itemBuilder: (context, index) {
                    final meal = viewModel.filterResults!.meals![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: meal.strMealThumb != null
                            ? Image.network(
                                meal.strMealThumb!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : SizedBox.shrink(),
                        title: Text(
                          meal.strMeal ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          meal.idMeal ?? '',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => MealDetailsViewModel(
                                  MealDetailsRepository(MealService(Dio())),
                                ),
                                child: MealDetailsPage(mealId: meal.idMeal!),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
