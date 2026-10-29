import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:kaam_fast/data/network/dio_exceptions.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'package:kaam_fast/utils/constants/shared_preferences_key.dart';

class DioClient {
  static const String baseUrl = AppUrls.baseUrl;
  late final Dio _dio;
  final Uuid _uuid = const Uuid();

  // Singleton pattern for shared networking
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(SharedPreferencesKey.token);
          final language = prefs.getString(SharedPreferencesKey.userLanguage) ?? 'en';
          final deviceId = prefs.getString(SharedPreferencesKey.deviceId) ?? 'device_app_01';

          options.headers['Accept'] = 'application/json';
          options.headers['Accept-Language'] = language;
          options.headers['X-Device-Platform'] = Platform.isIOS ? 'ios' : 'android';
          options.headers['X-Device-Id'] = deviceId;
          options.headers['X-Attestation-Token'] = 'local-bypass'; // Staging bypass

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Auto-generate Idempotency-Key for state-mutating requests if not already set
          if (['POST', 'PUT', 'DELETE'].contains(options.method.toUpperCase())) {
            if (!options.headers.containsKey('Idempotency-Key')) {
              options.headers['Idempotency-Key'] = _uuid.v4();
            }
          }

          if (kDebugMode) {
            debugPrint('🌐 REQUEST[${options.method}] => URL: ${options.uri}');
            if (options.data != null) {
              debugPrint('📦 BODY: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('✅ RESPONSE[${response.statusCode}] => URL: ${response.requestOptions.uri}');
            debugPrint('📄 DATA: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint('❌ ERROR[${e.response?.statusCode}] => URL: ${e.requestOptions.uri}');
            debugPrint('⚠️ ERROR BODY: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? idempotencyKey,
    Options? options,
  }) async {
    try {
      final reqOptions = options ?? Options();
      if (idempotencyKey != null) {
        reqOptions.headers = {
          ...?reqOptions.headers,
          'Idempotency-Key': idempotencyKey,
        };
      }
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: reqOptions,
      );
      return response.data;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
