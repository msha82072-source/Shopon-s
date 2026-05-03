class ProductModel {
  final String id;
  final String vendorId;
  final String? categoryId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final bool isActive;
  final DateTime createdAt;
  final List<String> images;
  final List<ProductVariant> variants;
  
  String get imageUrl => images.isNotEmpty ? images.first : '';
  String get vendorName => 'STORE #${vendorId.split('-').first.toUpperCase()}';

  ProductModel({
    required this.id,
    required this.vendorId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.isActive = true,
    required this.createdAt,
    this.images = const [],
    this.variants = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      vendorId: json['vendor_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      images: json['product_images'] != null 
          ? (json['product_images'] as List).map((i) => i['image_url'] as String).toList()
          : [],
      variants: json['product_variants'] != null
          ? (json['product_variants'] as List)
              .map((v) => ProductVariant.fromJson(v))
              .toList()
          : [],
    );
  }
}

class ProductVariant {
  final String id;
  final String? size;
  final String? color;
  final int stock;

  ProductVariant({
    required this.id,
    this.size,
    this.color,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      size: json['size'],
      color: json['color'],
      stock: json['stock'] ?? 0,
    );
  }
}
