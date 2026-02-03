import 'package:get/get.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../models/category.dart';

class HomeController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  var isLoading = true.obs;
  var currentBannerIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;

  var products = <Product>[].obs;
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      products.value = await _productService.getProducts();
      categories.value = await _productService.getCategories();
    } finally {
      isLoading.value = false;
    }
  }

  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    // In a real app, this would trigger a data filter
  }
}