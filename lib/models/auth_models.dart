import 'dart:convert';

LoginModels loginModelsFromJson(String str) =>
    LoginModels.fromJson(json.decode(str));

String loginModelsToJson(LoginModels data) => json.encode(data.toJson());

class LoginModels {
  String username;
  String password;

  LoginModels({
    required this.username,
    required this.password,
  });

  factory LoginModels.fromJson(Map<String, dynamic> json) => LoginModels(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
