class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final bool mustChangePassword;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
    this.mustChangePassword = false,
  });
}
