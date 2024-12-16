class User {
  final int id;
  final String name;
  final String email;
  final String token;
  final String avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json,
      {String? token, String? baseUrl}) {
    String avatarUrl =
        json['avatar_url'] ?? json['avatar'] ?? 'images/default-profile.png';
    baseUrl ??= 'http://localhost:8000';

    // Handle avatar URL
    if (!avatarUrl.startsWith('http')) {
      if (avatarUrl.startsWith('/')) {
        avatarUrl = avatarUrl.substring(1);
      }
      if (avatarUrl.startsWith('storage/')) {
        avatarUrl = '$baseUrl/$avatarUrl';
      } else {
        avatarUrl = '$baseUrl/storage/$avatarUrl';
      }
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: token ?? json['token'] ?? '',
      avatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatarUrl,
      };
}
