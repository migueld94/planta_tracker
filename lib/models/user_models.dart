import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String email;
  String fullName;

  User({
    required this.email,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "full_name": fullName,
      };
}
