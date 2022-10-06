import 'package:apdks/providers/auth.dart';
import 'package:apdks/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Result extends ChangeNotifier {
  final Auth? _authProvider;

  Result(this._authProvider) {
    if (_authProvider != null && _authProvider!.authenticated == true) {
      getHasil();
    } else {
      hasil = {};
    }
  }

  bool isFetching = true;
  Map hasil = {};

  void updateHasil(Map res) {
    hasil = res;
    isFetching = false;

    notifyListeners();
  }

  void getHasil() async {
    String? token = _authProvider?.token;

    Response response = await dio(token: token).get('hasil');

    if (response.statusCode == 200) {
      hasil = response.data['hasil'] ?? {};
      isFetching = false;
    }

    notifyListeners();
  }
}
