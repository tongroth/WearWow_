import 'package:get/get.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../data/mock_data.dart';

abstract class ProductService extends GetxService {
  Future<List<Product>> getProducts();
  Future<List<Category>> getCategories();
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<void> addCategory(Category category);
}

class MockProductService extends ProductService {
  final _products = <Product>[].obs;
  final _categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    _products.value = List.from(mockProducts);
    _categories.value = List.from(mockCategories);
  }

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }

  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories;
  }

  @override
  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _products.removeWhere((p) => p.id == id);
  }

  @override
  Future<void> addCategory(Category category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _categories.add(category);
  }
}

class FirebaseProductService extends ProductService {
  // To be implemented when Firestore is connected
  @override
  Future<List<Product>> getProducts() async => [];
  @override
  Future<List<Category>> getCategories() async => [];
  @override
  Future<void> addProduct(Product product) async {}
  @override
  Future<void> updateProduct(Product product) async {}
  @override
  Future<void> deleteProduct(String id) async {}
  @override
  Future<void> addCategory(Category category) async {}
}
