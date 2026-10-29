abstract class AuthEvent {}

class RequestOtpEvent extends AuthEvent {
  final String phone;
  final String role;
  RequestOtpEvent({required this.phone, required this.role});
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  final String role;
  VerifyOtpEvent({required this.phone, required this.otp, required this.role});
}

class QuickDemoLoginEvent extends AuthEvent {
  final String role;
  QuickDemoLoginEvent({required this.role});
}

class LogoutEvent extends AuthEvent {}
