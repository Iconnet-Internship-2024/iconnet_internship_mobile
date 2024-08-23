class User {
  final int id;
  final String username;
  final String email;
  final int roleId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roleId: json['roleId'],
    );
  }
}