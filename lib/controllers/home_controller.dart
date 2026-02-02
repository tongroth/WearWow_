import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var currentBannerIndex = 0.obs;
  var selectedCategoryIndex = 0.obs; // New: For category chips

  // New: List of categories for the chips
  final List<String> categories = ["All", "Women", "Men", "Shoes", "Accessories", "Sale"];

  @override
  void onInit() {
    super.onInit();
    // Simulate API loading
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }

  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    // In a real app, this would trigger a data filter
  }
}