class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String language;
  final String? role; // 'customer' or 'worker'
  final String? kycStatus; // 'none', 'pending', 'approved', 'rejected'
  final bool onDuty;
  final bool isTrained;
  final RatingModel? rating;
  final List<dynamic>? categories;
  final String? upiVpa;

  UserModel({
    required this.id,
    required this.phone,
    this.name,
    this.language = 'en',
    this.role,
    this.kycStatus,
    this.onDuty = false,
    this.isTrained = false,
    this.rating,
    this.categories,
    this.upiVpa,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? defaultRole}) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name']?.toString(),
      language: json['language']?.toString() ?? 'en',
      role: json['role']?.toString() ?? defaultRole,
      kycStatus: json['kyc_status']?.toString(),
      onDuty: json['on_duty'] == true,
      isTrained: json['is_trained'] == true,
      rating: json['rating'] is Map<String, dynamic>
          ? RatingModel.fromJson(json['rating'])
          : null,
      categories: json['categories'] is List ? json['categories'] : null,
      upiVpa: json['upi_vpa']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'language': language,
      'role': role,
      'kyc_status': kycStatus,
      'on_duty': onDuty,
      'is_trained': isTrained,
      'upi_vpa': upiVpa,
    };
  }
}

class RatingModel {
  final double average;
  final int count;

  RatingModel({required this.average, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] is num) ? (json['average'] as num).toDouble() : 0.0,
      count: (json['count'] is num) ? (json['count'] as num).toInt() : 0,
    );
  }
}
