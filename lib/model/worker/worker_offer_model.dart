import 'package:kaam_fast/model/booking/category_model.dart';

class WorkerOfferModel {
  final String bookingId;
  final CategoryModel? category;
  final int offeredAmountPaise;
  final int durationMinutes;
  final String? description;
  final String? addressText;
  final double? distanceMeters;
  final int secondsLeft;
  final DateTime? expiresAt;

  WorkerOfferModel({
    required this.bookingId,
    this.category,
    required this.offeredAmountPaise,
    required this.durationMinutes,
    this.description,
    this.addressText,
    this.distanceMeters,
    required this.secondsLeft,
    this.expiresAt,
  });

  factory WorkerOfferModel.fromJson(Map<String, dynamic> json) {
    final offer = json['offer'] is Map<String, dynamic> ? json['offer'] as Map<String, dynamic> : json;
    final loc = json['location'] is Map<String, dynamic> ? json['location'] as Map<String, dynamic> : null;

    return WorkerOfferModel(
      bookingId: json['id']?.toString() ?? offer['booking_id']?.toString() ?? '',
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'])
          : null,
      offeredAmountPaise: (json['offered_amount_paise'] is num)
          ? (json['offered_amount_paise'] as num).toInt()
          : 0,
      durationMinutes: (json['duration_minutes'] is num)
          ? (json['duration_minutes'] as num).toInt()
          : 60,
      description: json['description']?.toString(),
      addressText: loc?['address_text']?.toString() ?? json['address_text']?.toString(),
      distanceMeters: (offer['distance_m'] is num) ? (offer['distance_m'] as num).toDouble() : null,
      secondsLeft: (offer['seconds_left'] is num) ? (offer['seconds_left'] as num).toInt() : 45,
      expiresAt: offer['expires_at'] != null ? DateTime.tryParse(offer['expires_at'].toString()) : null,
    );
  }

  String get formattedDistance {
    if (distanceMeters == null) return 'Nearby';
    if (distanceMeters! >= 1000) {
      return '${(distanceMeters! / 1000).toStringAsFixed(1)} km away';
    }
    return '${distanceMeters!.toInt()} m away';
  }
}
