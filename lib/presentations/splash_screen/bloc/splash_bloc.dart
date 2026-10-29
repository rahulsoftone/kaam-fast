import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final StorageService _storageService = StorageService();

  SplashBloc() : super(SplashInitial()) {
    on<SplashInitEvent>((event, emit) async {
      emit(SplashLoading());
      await Future.delayed(const Duration(milliseconds: 1800));

      final token = await _storageService.getToken();
      final role = await _storageService.getRole();

      if (token != null && token.isNotEmpty) {
        emit(SplashNavigateToHome(role: role));
      } else {
        emit(SplashNavigateToAuth());
      }
    });
  }
}
