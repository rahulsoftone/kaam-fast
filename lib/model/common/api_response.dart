class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? severity;
  final String? requestId;
  final ApiErrorDetails? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.severity,
    this.requestId,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] == true,
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?,
      message: json['message']?.toString(),
      severity: json['severity']?.toString(),
      requestId: json['request_id']?.toString(),
      error: json['error'] != null ? ApiErrorDetails.fromJson(json['error']) : null,
    );
  }
}

class ApiErrorDetails {
  final String code;
  final String message;
  final String? severity;
  final Map<String, dynamic>? details;
  final Map<String, dynamic>? fields;

  ApiErrorDetails({
    required this.code,
    required this.message,
    this.severity,
    this.details,
    this.fields,
  });

  factory ApiErrorDetails.fromJson(Map<String, dynamic> json) {
    return ApiErrorDetails(
      code: json['code']?.toString() ?? 'UNKNOWN_ERROR',
      message: json['message']?.toString() ?? 'Something went wrong',
      severity: json['severity']?.toString(),
      details: json['details'] is Map<String, dynamic> ? json['details'] : null,
      fields: json['fields'] is Map<String, dynamic> ? json['fields'] : null,
    );
  }
}
