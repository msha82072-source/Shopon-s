enum UserRole { customer, vendor, admin }

class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final UserRole role;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.customer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role.name,
    };
  }
}
