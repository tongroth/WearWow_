import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../models/product.dart';
import '../widgets/admin_layout.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminController = Get.find<AdminController>();
  late final Product? _editingProduct;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _imageController = TextEditingController();
  String? _selectedCategory;
  bool _isNew = false;
  bool _isTrending = false;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _editingProduct = Get.arguments as Product?;
    if (_editingProduct != null) {
      _nameController.text = _editingProduct!.name;
      _priceController.text = _editingProduct!.price.toString();
      _originalPriceController.text = _editingProduct!.originalPrice?.toString() ?? "";
      _imageController.text = _editingProduct!.image;
      _selectedCategory = _editingProduct!.category;
      _isNew = _editingProduct!.isNew;
      _isTrending = _editingProduct!.isTrending;
      _rating = _editingProduct!.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: _editingProduct == null ? "Add New Product" : "Edit Product",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Basic Information"),
              _buildCard([
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                  validator: (value) => value == null || value.isEmpty ? "Enter name" : null,
                ),
                const SizedBox(height: 16),
                Obx(() => DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: "Category"),
                  items: _adminController.categories.map((c) => DropdownMenuItem(
                    value: c.name,
                    child: Text(c.name),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  validator: (value) => value == null ? "Select category" : null,
                )),
              ]),

              _buildSectionTitle("Pricing"),
              _buildCard([
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: "Price (\$)", prefixText: "\$"),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? "Enter price" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _originalPriceController,
                        decoration: const InputDecoration(labelText: "Original Price (\$)", prefixText: "\$"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ]),

              _buildSectionTitle("Media"),
              _buildCard([
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: "Main Image URL"),
                  validator: (value) => value == null || value.isEmpty ? "Enter image URL" : null,
                ),
              ]),

              _buildSectionTitle("Attributes"),
              _buildCard([
                SwitchListTile(
                  title: const Text("Is New Arrival"),
                  value: _isNew,
                  onChanged: (val) => setState(() => _isNew = val),
                  activeThumbColor: Theme.of(context).primaryColor,
                ),
                SwitchListTile(
                  title: const Text("Is Trending"),
                  value: _isTrending,
                  onChanged: (val) => setState(() => _isTrending = val),
                  activeThumbColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                const Text("Initial Rating", style: TextStyle(color: Colors.grey)),
                Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _rating.toString(),
                  onChanged: (val) => setState(() => _rating = val),
                ),
              ]),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_editingProduct == null ? "Add Product" : "Save Changes"),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: _editingProduct?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        originalPrice: _originalPriceController.text.isNotEmpty ? double.parse(_originalPriceController.text) : null,
        image: _imageController.text,
        category: _selectedCategory ?? "Uncategorized",
        isNew: _isNew,
        isTrending: _isTrending,
        rating: _rating,
      );

      if (_editingProduct == null) {
        _adminController.addProduct(updatedProduct);
      } else {
        _adminController.updateProduct(updatedProduct);
      }
    }
  }
}
