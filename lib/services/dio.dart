import 'package:dio/dio.dart';

Dio dio({String? token}) {
  Dio dio = Dio();

  // dio.options.baseUrl = "http://localhost:8000/api/";
  dio.options.baseUrl = "https://serviks.egols.my.id/api/";

  dio.options.headers['Accept'] = 'Application/json';
  if (token != null) {
    dio.options.headers['Authorization'] = "Bearer $token";
  }

  return dio;
}
