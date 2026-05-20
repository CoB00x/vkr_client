class User {
  final int id;
  final String phone;
  final String email;
  final String role;

  User({
    required this.id,
    required this.phone,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
    );
  }
}