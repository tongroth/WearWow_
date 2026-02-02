import '../models/product.dart';
import '../models/category.dart';
// import '../models/user_profile.dart';
import '../models/order.dart';

// --- EXPANDED PRODUCT LIST (6 Items) ---
final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Floral Summer Dress',
    price: 49.99,
    originalPrice: 79.99,
    image:
        'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=500&q=60',
    category: 'Women',
    rating: 4.5,
    isTrending: true,
  ),
  Product(
    id: '2',
    name: 'Casual Denim Jacket',
    price: 89.99,
    image:
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?auto=format&fit=crop&w=500&q=60',
    category: 'Men',
    rating: 4.8,
    isNew: true,
  ),
  Product(
    id: '3',
    name: 'Classic White Sneakers',
    price: 59.99,
    originalPrice: 89.99,
    image:
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=500&q=60',
    category: 'Shoes',
    rating: 4.7,
    isTrending: true,
  ),
  Product(
    id: '4',
    name: 'Leather Crossbody Bag',
    price: 129.99,
    image:
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=500&q=60',
    category: 'Accessories',
    rating: 4.6,
    isNew: true,
  ),
  Product(
    id: '5',
    name: 'Aviator Sunglasses',
    price: 29.99,
    image:
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&w=500&q=60',
    category: 'Accessories',
    rating: 4.4,
    isTrending: true,
  ),
  Product(
    id: '6',
    name: 'Minimalist Watch',
    price: 199.99,
    originalPrice: 249.99,
    image:
        'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=500&q=60',
    category: 'Accessories',
    rating: 4.9,
    isNew: true,
  ),
];

// --- EXPANDED CATEGORIES (4 Items) ---
final List<Category> mockCategories = [
  Category(
    id: 'women',
    name: 'Women',
    icon: '👗',
    image: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&q=80',
    subcategories: ['Dresses', 'Tops', 'Skirts'],
  ),
  Category(
    id: 'men',
    name: 'Men',
    icon: '👔',
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
    subcategories: ['Shirts', 'Jeans', 'Suits'],
  ),
  Category(
    id: 'shoes',
    name: 'Shoes',
    icon: '👟',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
    subcategories: ['Sneakers', 'Heels', 'Boots'],
  ),
  Category(
    id: 'accessories',
    name: 'Accessories',
    icon: '👜',
    image: 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=400&q=80',
    subcategories: ['Bags', 'Watches', 'Jewelry'],
  ),
];

// --- USER & ORDERS ---
// final mockUser = UserProfile(
//   name: "Alex Doe",
//   email: "alex.doe@example.com",
//   avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fit=crop&w=200&h=200",
// );

final mockOrders = [
  Order(id: "#ORD-7782", date: DateTime.now().subtract(const Duration(days: 2)), status: OrderStatus.processing, total: 129.98, itemCount: 2),
  Order(id: "#ORD-7781", date: DateTime.now().subtract(const Duration(days: 15)), status: OrderStatus.delivered, total: 59.99, itemCount: 1),
];
