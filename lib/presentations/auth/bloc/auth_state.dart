import 'package:kaam_fast/model/auth/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String phone;
  final String message;
  final String role;
  OtpSentSuccess({required this.phone, required this.message, required this.role});
}

class AuthSuccess extends AuthState {
  final UserModel user;
  final String role;
  AuthSuccess({required this.user, required this.role});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  final String? errorCode;
  AuthFailure({required this.errorMessage, this.errorCode});
}
