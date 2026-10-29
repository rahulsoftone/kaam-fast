abstract class OfferTimerEvent {}

class StartTimerEvent extends OfferTimerEvent {
  final int totalSeconds;
  StartTimerEvent({this.totalSeconds = 45});
}

class TimerTickEvent extends OfferTimerEvent {
  final int remainingSeconds;
  TimerTickEvent({required this.remainingSeconds});
}

class AcceptOfferEvent extends OfferTimerEvent {
  final String bookingId;
  AcceptOfferEvent({required this.bookingId});
}

class RejectOfferEvent extends OfferTimerEvent {
  final String bookingId;
  RejectOfferEvent({required this.bookingId});
}
