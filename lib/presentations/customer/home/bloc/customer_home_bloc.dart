import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaam_fast/model/booking/booking_model.dart';
import 'package:kaam_fast/model/booking/category_model.dart';
import 'package:kaam_fast/presentations/customer/home/repository/customer_home_repository.dart';
import 'customer_home_event.dart';
import 'customer_home_state.dart';

class CustomerHomeBloc extends Bloc<CustomerHomeEvent, CustomerHomeState> {
  final CustomerHomeRepository _repository = CustomerHomeRepository();

  CustomerHomeBloc() : super(CustomerHomeInitial()) {
    on<LoadCustomerHomeEvent>((event, emit) async {
      emit(CustomerHomeLoading());
      List<CategoryModel> categories = [];
      List<BookingModel> bookings = [];
      try {
        categories = await _repository.getCategories();
      } catch (_) {
        categories = _repository.fallbackCategories();
      }
      try {
        bookings = await _repository.getMyBookings();
      } catch (_) {
        bookings = [];
      }
      emit(CustomerHomeLoaded(
        categories: categories.isNotEmpty ? categories : _repository.fallbackCategories(),
        activeBookings: bookings,
      ));
    });
  }
}
