class WalletModel {
  final int balancePaise;
  final int holdPaise;
  final String currency;
  final List<WalletEntryModel> entries;

  WalletModel({
    required this.balancePaise,
    this.holdPaise = 0,
    this.currency = 'INR',
    this.entries = const [],
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balancePaise: (json['balance_paise'] is num) ? (json['balance_paise'] as num).toInt() : 0,
      holdPaise: (json['hold_paise'] is num) ? (json['hold_paise'] as num).toInt() : 0,
      currency: json['currency']?.toString() ?? 'INR',
      entries: json['entries'] is List
          ? (json['entries'] as List)
              .map((e) => WalletEntryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  bool get canAcceptJob => balancePaise >= 2500; // Rs 25 minimum required
}

class WalletEntryModel {
  final String id;
  final String type; // credit, debit
  final int amountPaise;
  final String description;
  final DateTime? createdAt;

  WalletEntryModel({
    required this.id,
    required this.type,
    required this.amountPaise,
    required this.description,
    this.createdAt,
  });

  factory WalletEntryModel.fromJson(Map<String, dynamic> json) {
    return WalletEntryModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'debit',
      amountPaise: (json['amount_paise'] is num) ? (json['amount_paise'] as num).toInt() : 0,
      description: json['description']?.toString() ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
