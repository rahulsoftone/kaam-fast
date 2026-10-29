abstract class OfferTimerState {}

class OfferTimerInitial extends OfferTimerState {}

class OfferTimerRunning extends OfferTimerState {
  final int secondsLeft;
  final double progress; // 1.0 down to 0.0
  OfferTimerRunning({required this.secondsLeft, required this.progress});
}

class OfferTimerExpired extends OfferTimerState {}

class OfferAccepting extends OfferTimerState {}

class OfferAcceptedSuccess extends OfferTimerState {
  final String bookingId;
  final int feeChargedPaise;
  OfferAcceptedSuccess({required this.bookingId, this.feeChargedPaise = 2500});
}

class OfferAcceptFailure extends OfferTimerState {
  final String errorMessage;
  final String errorCode;
  OfferAcceptFailure({required this.errorMessage, required this.errorCode});
}

class OfferRejectedState extends OfferTimerState {}
