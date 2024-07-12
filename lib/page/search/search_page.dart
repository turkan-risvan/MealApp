import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/page/meal_filter/meal_filter_page.dart';
import 'package:recipes_app/page/meal_filter/meal_filter_viewmodel.dart';
import 'package:recipes_app/page/search/search_viewmodel.dart';
import 'package:recipes_app/page/details/meal_details_page.dart';
import 'package:recipes_app/page/details/meal_details_viewmodel.dart';
import 'package:recipes_app/data/service/meal_service.dart';
import 'package:recipes_app/data/repo/repository.dart';
import 'package:dio/dio.dart';

class SearchPage extends StatefulWidget {
  final MealFilterRepository mealFilterRepository;

  const SearchPage({super.key, required this.mealFilterRepository});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: (value) {
                  Provider.of<SearchViewModel>(context, listen: false)
                      .searchMeals(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Yemek ara...',
                  border: InputBorder.none,
                ),
              )
            : Text('*'),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.clear : Icons.search,
              color: Color(0xffff774d),
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  // Clear search results when closing search
                  Provider.of<SearchViewModel>(context, listen: false);

                  _searchController.clear(); // Clear the search input field
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ChangeNotifierProvider(
            create: (context) =>MealFilterViewModel(widget.mealFilterRepository),
            child: Container(
              height: 500,
              width: double.infinity,
              child: MealFilterPage(),
            ),
          ),
               
          if (_isSearching)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                height: 200,
                child: _buildSearchResults(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return Center(
      //child: Container(color: Colors.red,),
      //child: Text("Press the search button to start searching."),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchViewModel>(
      builder: (context, model, child) {
        if (model.searchResults == null) {
          return const Center(
              //  child: CircularProgressIndicator(),
              );
        }

        if (model.errorMessage != null) {
          return Center(
            child: Text(
              model.errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return ListView.builder(
          itemCount: model.searchResults!.meals!.length,
          itemBuilder: (context, index) {
            final meal = model.searchResults!.meals![index];
            return ListTile(
              title: Text(meal.strMeal ?? ''),
              subtitle: Text(meal.strCategory ?? ''),
              leading: meal.strMealThumb != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(meal.strMealThumb!),
                    )
                  : null,
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
            );
          },
        );
      },
    );
  }
}
