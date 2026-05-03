class VendorProfileModel {
  final String id;
  final String userId;
  final String storeName;
  final String? storeLogoUrl;
  final String? description;
  final bool isApproved;
  final double rating;

  VendorProfileModel({
    required this.id,
    required this.userId,
    required this.storeName,
    this.storeLogoUrl,
    this.description,
    this.isApproved = false,
    this.rating = 0.0,
  });

  factory VendorProfileModel.fromJson(Map<String, dynamic> json) {
    return VendorProfileModel(
      id: json['id'],
      userId: json['user_id'],
      storeName: json['store_name'],
      storeLogoUrl: json['store_logo_url'],
      description: json['description'],
      isApproved: json['is_approved'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
