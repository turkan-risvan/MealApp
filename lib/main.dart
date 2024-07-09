import 'package:flutter/material.dart';
 
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/data/repo/repository.dart';
import 'package:recipes_app/data/service/meal_service.dart';
import 'package:recipes_app/page/search/search_page.dart';
import 'package:recipes_app/page/search/search_viewmodel.dart';
 
 

void main() {
  final dio = Dio(); // Dio instance for network calls
  final mealService = MealService(dio); // MealService instance
  final mealRepository = SearchRepository(mealService); // MealRepository instance

  runApp(
    ChangeNotifierProvider(
      create: (context) => SearchViewModel(mealRepository),
      child: MaterialApp(
        title: 'Meal Search App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SearchPage(),
      ),
    ),
  );
}
