import 'dart:convert';
import 'package:http/http.dart';
import 'package:planta_tracker/assets/utils/constants.dart';

class AuthService {
  var forgotPasswordUri =
      Uri.parse('${Constants.baseUrl}/en/api/password_recover/');
  var changePasswordUri =
      Uri.parse('${Constants.baseUrl}/en/api/password_changed/');
  var loginUri = Uri.parse('${Constants.baseUrl}/en/api/login/');
  var logoutUri = Uri.parse('${Constants.baseUrl}/es/api/logout/');
  var registerUri = Uri.parse('${Constants.baseUrl}/en/api/users_api');
  var verifyUri = Uri.parse('${Constants.baseUrl}/es/api/activate_account_api');
  var resendCodeUri =
      Uri.parse('${Constants.baseUrl}/en/api/resend_activate_account_api');
  var secretUrl = Uri.parse('${Constants.baseUrl}/en/api/o/token/');

  Future<Response?> login(String username, String password) async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var res = await post(loginUri, headers: <String, String>{
      'authorization': "Bearer $accessToken"
    }, body: {
      "username": username,
      "password": password,
    });

    return res;
  }

  Future<Response?> register(
      String email, String name, String password, String password2) async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var res = await post(registerUri, headers: <String, String>{
      'authorization': "Bearer $accessToken"
    }, body: {
      "email": email,
      "full_name": name,
      "password": password,
      "password2": password2,
    });
    return res;
  }

  Future<Response?> verifyCode(String email, String code) async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    // aqui recibo el token de acceso
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var res = await post(verifyUri, headers: <String, String>{
      'authorization': "Bearer $accessToken"
    }, body: {
      "email": email,
      "code": code,
    });
    return res;
  }

  Future<Response?> resendCodeActivatition(String email) async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var res = await post(resendCodeUri, headers: <String, String>{
      'authorization': "Bearer $accessToken"
    }, body: {
      "email": email,
    });
    return res;
  }

  Future<Response?> logout(String token) async {
    var res = await post(logoutUri,
        headers: <String, String>{'authorization': "Token $token"});

    return res;
  }

  Future<Response?> forgotPassword(String email) async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var res = await post(forgotPasswordUri, headers: <String, String>{
      'authorization': "Bearer $accessToken"
    }, body: {
      "email": email,
    });

    return res;
  }

  Future<Response?> changePassword(String email, String newPassword,
      String newConfirmPassword, String code) async {
    String client = 'IMIUgjEXwzviJeCfVzCQw4g8GkhUpYGbcDieCxSE';
    String secret =
        'rOsMV2OjTPs89ku5NlWuukWNMfm9CDO3nZuzOxRWYCPUSSxnZcCfUl8XnU1HcPTfCqCTpZxYhv3zNYUB0H1hlQ6b7heLWsoqgJjLSkwAsZp7NTwT2B1D8nwfTS6bfvpw';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';
    var response = await post(secretUrl, headers: <String, String>{
      'authorization': basicAuth
    }, body: {
      "grant_type": "client_credentials",
    });

    final Map<String, dynamic> data = json.decode(response.body);
    final accessToken = data["access_token"];

    var res = await post(changePasswordUri, headers: <String, String>{
      'authorization': "Bearer $accessToken"
    }, body: {
      "email": email,
      "password": newPassword,
      "password2": newConfirmPassword,
      "code": code,
    });

    return res;
  }
}
