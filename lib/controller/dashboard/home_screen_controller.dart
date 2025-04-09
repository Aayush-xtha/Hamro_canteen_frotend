import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/repo/get_food_repo.dart';

import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  // Loading states
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Data containers
  var allCategories = <FoodDetails>[].obs;
  var allFoodDetails =
      <FoodDetails>[].obs; // Store all food details for category filtering
  var vegItems = <Foods>[].obs;
  var nonVegItems = <Foods>[].obs;
  var popularItems = <Foods>[].obs;

  // Search functionality
  var searchQuery = ''.obs;
  var searchResults = <Foods>[].obs;
  var isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoodData();
  }

  // Fetch all food data from repository
  Future<void> fetchFoodData() async {
    isLoading.value = true;
    errorMessage.value = '';

    await GetFoodRepo.getFoodRepo(
      onSuccess: (foodData) {
        // Store all food details
        allFoodDetails.assignAll(foodData);

        // Store all categories
        allCategories.assignAll(foodData);

        // Extract all food items from all categories
        List<Foods> allFoods = [];
        for (var category in foodData) {
          if (category.foods != null) {
            allFoods.addAll(category.foods!);
          }
        }

        // Filter vegetarian items (containing "veg" in name)
        vegItems.assignAll(allFoods
            .where(
                (food) => food.foodName?.toLowerCase().contains('veg') ?? false)
            .toList());

        // Filter non-vegetarian items (not containing "veg" in name)
        nonVegItems.assignAll(allFoods
            .where((food) =>
                !(food.foodName?.toLowerCase().contains('veg') ?? false))
            .toList());

        // Sort by sold count for popular items (if available)
        // List<Foods> sortedByPopularity = List.from(allFoods);
        // sortedByPopularity.sort((a, b) =>
        //   (b.soldCount ?? 0).compareTo(a.soldCount ?? 0)
        // );
        // popularItems.assignAll(sortedByPopularity.take(10).toList());

        isLoading.value = false;
      },
      onError: (message) {
        errorMessage.value = message;
        isLoading.value = false;
      },
    );
  }

  // Search functionality
  void search(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    searchQuery.value = query;

    // Extract all food items from all categories
    List<Foods> allFoods = [];
    for (var category in allCategories) {
      if (category.foods != null) {
        allFoods.addAll(category.foods!);
      }
    }

    // Filter by search query
    final queryLower = query.toLowerCase();
    searchResults.assignAll(allFoods
        .where((food) =>
            (food.foodName?.toLowerCase().contains(queryLower) ?? false) ||
            (food.description?.toLowerCase().contains(queryLower) ?? false))
        .toList());
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  // View all functions for each section
  void viewAllVegItems() {
    // Navigate to a page showing all veg items
    // Get.to(() => AllVegItemsScreen(items: vegItems));
  }

  void viewAllNonVegItems() {
    // Navigate to a page showing all non-veg items
    // Get.to(() => AllNonVegItemsScreen(items: nonVegItems));
  }

  void viewAllPopularItems() {
    // Navigate to a page showing all popular items
    // Get.to(() => AllPopularItemsScreen(items: popularItems));
  }
}
