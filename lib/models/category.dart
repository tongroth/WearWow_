class Category {
  final String id;
  final String name;
  final String icon;  // Emoji or Icon name
  final String image; // URL for the background image
  final List<String> subcategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.subcategories,
  });

  // Recommended: Add JSON serialization for when you connect Firebase
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'image': image,
    'subcategories': subcategories,
  };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    image: json['image'],
    subcategories: List<String>.from(json['subcategories'] ?? []),
  );
}