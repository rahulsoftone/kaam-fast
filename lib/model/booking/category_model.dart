class CategoryModel {
  final int id;
  final String slug;
  final String name;
  final int? extraHourRatePaise;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    this.extraHourRatePaise,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      extraHourRatePaise: json['extra_hour_rate_paise'] is int ? json['extra_hour_rate_paise'] : null,
    );
  }

  // Icon mapper helper
  String get iconName {
    final s = slug.toLowerCase();
    if (s.contains('plumb')) return 'plumbing';
    if (s.contains('electr')) return 'electrical_services';
    if (s.contains('carpen')) return 'carpenter';
    if (s.contains('clean') || s.contains('maid')) return 'cleaning_services';
    if (s.contains('paint')) return 'format_paint';
    if (s.contains('driv')) return 'directions_car';
    return 'handyman';
  }
}
