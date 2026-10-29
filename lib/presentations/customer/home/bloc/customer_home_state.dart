import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/model/booking/category_model.dart';

abstract class CustomerHomeState {}

class CustomerHomeInitial extends CustomerHomeState {}

class CustomerHomeLoading extends CustomerHomeState {}

class CustomerHomeLoaded extends CustomerHomeState {
  final List<CategoryModel> categories;
  final List<BookingModel> activeBookings;

  CustomerHomeLoaded({
    required this.categories,
    required this.activeBookings,
  });
}

class CustomerHomeFailure extends CustomerHomeState {
  final String errorMessage;
  CustomerHomeFailure({required this.errorMessage});
}
