class ReviewModel {
  final String id;
  final String userId;
  final String? userName;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['user_id'],
      userName: json['users']?['full_name'], // Map from related users table
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
