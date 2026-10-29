import 'package:kaam_fast/model/booking/category_model.dart';

class BookingModel {
  final String id;
  final String status;
  final CategoryModel? category;
  final int offeredAmountPaise;
  final int durationMinutes;
  final int? extraHourRatePaise;
  final String? description;
  final String? addressText;
  final double? latitude;
  final double? longitude;
  final AssignedWorkerModel? worker;
  final PaymentQrModel? paymentQr;
  final List<String> actions;
  final DateTime? createdAt;
  final DateTime? acceptedAt;
  final DateTime? arrivedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  BookingModel({
    required this.id,
    required this.status,
    this.category,
    required this.offeredAmountPaise,
    required this.durationMinutes,
    this.extraHourRatePaise,
    this.description,
    this.addressText,
    this.latitude,
    this.longitude,
    this.worker,
    this.paymentQr,
    this.actions = const [],
    this.createdAt,
    this.acceptedAt,
    this.arrivedAt,
    this.startedAt,
    this.completedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'draft',
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'])
          : null,
      offeredAmountPaise: (json['offered_amount_paise'] is num)
          ? (json['offered_amount_paise'] as num).toInt()
          : 0,
      durationMinutes: (json['duration_minutes'] is num)
          ? (json['duration_minutes'] as num).toInt()
          : 60,
      extraHourRatePaise: json['extra_hour_rate_paise'] is num
          ? (json['extra_hour_rate_paise'] as num).toInt()
          : null,
      description: json['description']?.toString(),
      addressText: json['address_text']?.toString() ??
          (json['location'] is Map ? json['location']['address_text']?.toString() : null),
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : (json['location'] is Map && json['location']['latitude'] is num
              ? (json['location']['latitude'] as num).toDouble()
              : null),
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : (json['location'] is Map && json['location']['longitude'] is num
              ? (json['location']['longitude'] as num).toDouble()
              : null),
      worker: json['worker'] is Map<String, dynamic>
          ? AssignedWorkerModel.fromJson(json['worker'])
          : null,
      paymentQr: json['payment_qr'] is Map<String, dynamic>
          ? PaymentQrModel.fromJson(json['payment_qr'])
          : null,
      actions: json['actions'] is List
          ? (json['actions'] as List).map((e) => e.toString()).toList()
          : [],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      acceptedAt: json['accepted_at'] != null ? DateTime.tryParse(json['accepted_at'].toString()) : null,
      arrivedAt: json['arrived_at'] != null ? DateTime.tryParse(json['arrived_at'].toString()) : null,
      startedAt: json['started_at'] != null ? DateTime.tryParse(json['started_at'].toString()) : null,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'].toString()) : null,
    );
  }

  bool canPerformAction(String action) => actions.contains(action);
}

class AssignedWorkerModel {
  final String id;
  final String? name;
  final String? phone;
  final double? ratingAverage;
  final bool isTrained;

  AssignedWorkerModel({
    required this.id,
    this.name,
    this.phone,
    this.ratingAverage,
    this.isTrained = false,
  });

  factory AssignedWorkerModel.fromJson(Map<String, dynamic> json) {
    return AssignedWorkerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      ratingAverage: (json['rating'] is Map && json['rating']['average'] is num)
          ? (json['rating']['average'] as num).toDouble()
          : null,
      isTrained: json['is_trained'] == true,
    );
  }
}

class PaymentQrModel {
  final String? upiUri;
  final String? vpa;
  final int? amountPaise;

  PaymentQrModel({this.upiUri, this.vpa, this.amountPaise});

  factory PaymentQrModel.fromJson(Map<String, dynamic> json) {
    return PaymentQrModel(
      upiUri: json['upi_uri']?.toString(),
      vpa: json['vpa']?.toString(),
      amountPaise: json['amount_paise'] is num ? (json['amount_paise'] as num).toInt() : null,
    );
  }
}
