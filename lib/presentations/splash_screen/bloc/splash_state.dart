abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashNavigateToHome extends SplashState {
  final String role;
  SplashNavigateToHome({required this.role});
}

class SplashNavigateToAuth extends SplashState {}
