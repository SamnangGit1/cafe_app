class AuthUser {
  const AuthUser({
    required this.userId,
    required this.username,
    required this.email,
    this.image,
    this.isAdmin = false,
    this.permissions = const [],
  });

  final int userId;
  final String username;
  final String email;
  final String? image;
  final bool isAdmin;
  final List<dynamic> permissions;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['UserID'] as int,
      username: json['Username'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      image: json['Image'] as String?,
      isAdmin: json['IsAdmin'] as bool? ?? false,
      permissions: json['Permissions'] as List<dynamic>? ?? const [],
    );
  }
}

class AuthResponse {
  const AuthResponse({required this.token, required this.user});

  final String token;
  final AuthUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: (json['token'] ?? json['Token'] ?? '') as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}