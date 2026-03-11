import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.name,
    required super.email,
    required super.role
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role
    };
  }
}
