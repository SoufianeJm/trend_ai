import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({String? baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? 'https://api.snrtbotola.ma')) {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    // Add retry or auth interceptors if needed
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);

  // Add more methods if needed
}
