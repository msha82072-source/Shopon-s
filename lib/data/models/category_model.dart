class CategoryModel {
  final String id;
  final String name;
  final String? parentId;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      imageUrl: json['image_url'],
    );
  }
}
