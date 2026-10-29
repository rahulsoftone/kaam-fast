import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';

class CustomerHomeRepository {
  final DioClient _dioClient = DioClient();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final res = await _dioClient.get(AppUrls.categories);
      if (res is Map<String, dynamic> && res['data'] is List) {
        return (res['data'] as List)
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    // Fallback default categories if offline / initial setup
    return fallbackCategories();
  }

  List<CategoryModel> fallbackCategories() => [
    CategoryModel(id: 1, slug: 'plumber', name: 'Plumber', extraHourRatePaise: 20000),
    CategoryModel(id: 2, slug: 'electrician', name: 'Electrician', extraHourRatePaise: 25000),
    CategoryModel(id: 3, slug: 'carpenter', name: 'Carpenter', extraHourRatePaise: 30000),
    CategoryModel(id: 4, slug: 'cleaning', name: 'Cleaning & Maid', extraHourRatePaise: 15000),
    CategoryModel(id: 5, slug: 'painter', name: 'Painter', extraHourRatePaise: 25000),
    CategoryModel(id: 6, slug: 'mason', name: 'Mason', extraHourRatePaise: 20000),
    CategoryModel(id: 7, slug: 'ac-technician', name: 'AC Technician', extraHourRatePaise: 25000),
    CategoryModel(id: 8, slug: 'labourer', name: 'Labourer', extraHourRatePaise: 8000),
  ];

  Future<List<BookingModel>> getMyBookings() async {
    try {
      final res = await _dioClient.get(AppUrls.customerBookings);
      if (res is Map<String, dynamic> && res['data'] is List) {
        return (res['data'] as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
