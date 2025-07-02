import 'package:dio/dio.dart';

import '../sensitive_data.dart';

class ApiServices {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: supabaseUrl, headers: {"apiKey": anonKey}),
  );

  /// Get Data
  Future<Response> getData(String path, String? token) async {
    return await _dio.get(
      path,
      options: Options(
        headers: {"apiKey": anonKey, "Authorization": "Bearer $token"},
      ),
    );
  }

  /// Add Data
  Future<Response> postData(
    String path,
    Map<String, dynamic> data,
    String? token,
  ) async {
    return await _dio.post(
      path,
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  /// Add/Update Data
  Future<Response> patchData(
    String path,
    Map<String, dynamic> data,
    String? token,
  ) async {
    return await _dio.patch(
      path,
      data: data,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  /// Delete Data
  Future<Response> deleteData(String path, String? token) async {
    return await _dio.delete(
      path,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  /// Auth
  final Dio _dioAuth = Dio(
    BaseOptions(baseUrl: authUrl, headers: {"apiKey": anonKey}),
  );

  /// Sign Up
  Future<Response> createAnAccount(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    return await _dioAuth.post(endpoint, data: data);
  }

  /// Login
  Future<Response> login(String endpoint, Map<String, dynamic> data) async {
    return await _dioAuth.post(
      endpoint,
      data: data,
      queryParameters: {"grant_type": "password"},
    );
  }
}
