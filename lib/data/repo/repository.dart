 
import 'package:recipes_app/data/service/meal_service.dart';
import 'package:recipes_app/model/area/area_model.dart';
import 'package:recipes_app/model/area_filter/area_filter_model.dart';
 
 
 
 
import 'package:recipes_app/model/list_category/list_category_model.dart';
import 'package:recipes_app/model/meal_details/meal_deails_model.dart';
import 'package:recipes_app/model/meal_filter/meal_filter_model.dart';
 
import 'package:recipes_app/model/meal_random/meal_random_model.dart';
import 'package:recipes_app/model/search/search_model.dart';
 
 
import 'package:retrofit/dio.dart';

// class CategoriesRepository {
//   final MealService _mealService;

//   CategoriesRepository(this._mealService);

//   Future<CategoriesModel> fetchCategories() async {
//     try {
//       return await _mealService.getCategories();
//     } catch (e) {
//       throw Exception('Failed to load categories: $e');
//     }
//   }
// }

 


class MealDetailsRepository {
  final MealService _mealService;

  MealDetailsRepository(this._mealService);

  Future<MealDetailsModel> fetchMealDetails(String id) async {
    try {
      final response = await _mealService.getMealDetails(id);
      return response.data!;
    } catch (e) {
      throw Exception('Failed to load meal details: $e');
    }
  }
}




class SearchRepository {
  final MealService _service;

  SearchRepository(this._service);

  Future<HttpResponse<SearchModel>> searchMeal(String query) => _service.searchMeal(query);
}
 

 

class MealFilterRepository {
  final MealService _service;

  MealFilterRepository(this._service);

  Future<HttpResponse<MealFilterModel>> filterMeal(String query) => _service.filterMeal(query);

  Future<HttpResponse<ListCategoryModel>> listCategoryMeal() => _service.listCategoryMeal();
}


class AreaFilterRepository {
  final MealService _service;

  AreaFilterRepository(this._service);

  Future<HttpResponse<AreaFilterModel>> filterArea(String query) => _service.filterArea(query);

  Future<HttpResponse<AreaModel>> listAreaMeal() => _service.listAreaMeal();
}



 

 class RandomRepository {
  final MealService _service;

  RandomRepository(this._service);
  Future<HttpResponse<MealRandomModel>> getRandomMeal() =>_service.getRandomMeal();
}


 

 



