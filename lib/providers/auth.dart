import 'package:apdks/models/user.dart';
import 'package:apdks/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  String? token;
  User? user;
  bool? authenticated;

  String? errorMsg;
  final storage = const FlutterSecureStorage();

  void userData(String token) async {
    try {
      Response response = await dio(token: token).get('me');

      this.token = token;
      user = User.fromJson(response.data['user']);
      authenticated = true;
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        await storage.delete(key: "token");
      }
      authenticated = false;
    }

    notifyListeners();
  }

  void updateUser(userData) {
    user = User.fromJson(userData);

    notifyListeners();
  }

  void login({required Map creds}) async {
    errorMsg = null;

    try {
      Response response = await dio().post('login', data: creds);

      token = response.data['token'];
      await storage.write(key: "token", value: response.data['token']);
      user = User.fromJson(response.data['user']);
      authenticated = true;
    } on DioError catch (e) {
      errorMsg = "${e.response!.data['message']}";
      authenticated = false;
    }

    notifyListeners();
  }

  void logout() async {
    Response response = await dio(token: token).get('logout');

    if (response.statusCode == 200) {
      token = null;
      user = null;
      authenticated = null;
      await storage.delete(key: "token");
    }

    notifyListeners();
  }
}
