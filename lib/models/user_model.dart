class UserModel {
  final String username;
  final String accessToken;

  UserModel({required this.username, required this.accessToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  } 
}