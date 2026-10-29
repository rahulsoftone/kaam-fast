import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/data/network/dio_exceptions.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';
import 'offer_timer_event.dart';
import 'offer_timer_state.dart';

class OfferTimerBloc extends Bloc<OfferTimerEvent, OfferTimerState> {
  final DioClient _dioClient = DioClient();
  StreamSubscription<int>? _tickerSubscription;
  final int _totalSeconds = 45;

  OfferTimerBloc() : super(OfferTimerInitial()) {
    on<StartTimerEvent>((event, emit) {
      _tickerSubscription?.cancel();
      emit(OfferTimerRunning(secondsLeft: _totalSeconds, progress: 1.0));

      _tickerSubscription = Stream.periodic(
        const Duration(seconds: 1),
        (x) => _totalSeconds - x - 1,
      ).take(_totalSeconds).listen((remaining) {
        add(TimerTickEvent(remainingSeconds: remaining));
      });
    });

    on<TimerTickEvent>((event, emit) {
      if (event.remainingSeconds <= 0) {
        _tickerSubscription?.cancel();
        emit(OfferTimerExpired());
      } else {
        emit(OfferTimerRunning(
          secondsLeft: event.remainingSeconds,
          progress: event.remainingSeconds / _totalSeconds,
        ));
      }
    });

    on<AcceptOfferEvent>((event, emit) async {
      _tickerSubscription?.cancel();
      emit(OfferAccepting());
      try {
        final res = await _dioClient.post(AppUrls.workerAcceptOffer(event.bookingId));
        final fee = res['data']?['charge']?['fee_paise'] ?? 2500;
        emit(OfferAcceptedSuccess(bookingId: event.bookingId, feeChargedPaise: fee));
      } on DioExceptions catch (e) {
        emit(OfferAcceptFailure(
          errorMessage: e.message,
          errorCode: e.errorCode ?? 'ACCEPT_FAILED',
        ));
      } catch (e) {
        emit(OfferAcceptFailure(
          errorMessage: e.toString(),
          errorCode: 'ERROR',
        ));
      }
    });

    on<RejectOfferEvent>((event, emit) async {
      _tickerSubscription?.cancel();
      try {
        await _dioClient.post(AppUrls.workerRejectOffer(event.bookingId));
      } catch (_) {}
      emit(OfferRejectedState());
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
