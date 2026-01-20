
class UserModel {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String? bio;
  final String? profilePicture;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.bio,
    this.profilePicture,
    required this.role,
  });

  //FROM JSON
  // API response theke UserModel create koro
  // Usage: UserModel.fromJson(jsonData)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'],
      profilePicture: json['profile_picture'],
      role: json['role'] ?? 'event_admin',
    );
  }

  // ====== TO JSON ======
  // UserModel ke JSON e convert koro
  // Storage e save korar jonno
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'bio': bio,
    'profile_picture': profilePicture,
    'role': role,
  };
}