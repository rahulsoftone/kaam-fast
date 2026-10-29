import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;
  String? errorCode;
  String? severity;
  String? requestId;
  Map<String, dynamic>? fields;
  Map<String, dynamic>? details;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request was cancelled";
        errorCode = "REQUEST_CANCELLED";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout. Please check your internet.";
        errorCode = "CONNECTION_TIMEOUT";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Server response timeout. Please try again.";
        errorCode = "RECEIVE_TIMEOUT";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout with server.";
        errorCode = "SEND_TIMEOUT";
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection detected.";
        errorCode = "NO_INTERNET";
        break;
      case DioExceptionType.badResponse:
        _handleBadResponse(dioError.response);
        break;
      default:
        message = "An unexpected error occurred.";
        errorCode = "UNKNOWN_ERROR";
        break;
    }
  }

  void _handleBadResponse(Response? response) {
    if (response == null || response.data == null) {
      message = "Server returned empty response.";
      errorCode = "EMPTY_RESPONSE";
      return;
    }

    final data = response.data;
    if (data is Map<String, dynamic>) {
      requestId = data['request_id']?.toString();
      severity = data['severity']?.toString();

      // Check standard KaamFast error object: { error: { code, message, severity, details, fields } }
      if (data['error'] is Map<String, dynamic>) {
        final err = data['error'] as Map<String, dynamic>;
        errorCode = err['code']?.toString() ?? 'ERROR_${response.statusCode}';
        message = err['message']?.toString() ?? _defaultMessageForCode(response.statusCode);
        severity = err['severity']?.toString() ?? severity;
        if (err['fields'] is Map<String, dynamic>) {
          fields = err['fields'] as Map<String, dynamic>;
        }
        if (err['details'] is Map<String, dynamic>) {
          details = err['details'] as Map<String, dynamic>;
        }
        return;
      }

      // Fallback for simple message field
      message = data['message']?.toString() ?? _defaultMessageForCode(response.statusCode);
      errorCode = data['code']?.toString() ?? 'HTTP_${response.statusCode}';
      return;
    }

    message = _defaultMessageForCode(response.statusCode);
  }

  String _defaultMessageForCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please verify inputs.';
      case 401:
        return 'Session expired. Please log in again.';
      case 402:
        return 'Payment or wallet balance required.';
      case 403:
        return 'Access denied or account suspended.';
      case 404:
        return 'Requested item not found.';
      case 409:
        return 'Action conflict. The job or status may have already changed.';
      case 422:
        return 'Validation failed. Please check the entered fields.';
      case 429:
        return 'Too many requests. Please wait a moment.';
      case 500:
        return 'Internal server error. Please try again shortly.';
      case 503:
        return 'Service temporarily unavailable.';
      default:
        return 'Server error ($statusCode).';
    }
  }

  @override
  String toString() => message;
}
