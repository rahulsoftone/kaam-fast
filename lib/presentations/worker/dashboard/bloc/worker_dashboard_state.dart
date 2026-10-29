import 'package:kaam_fast/model/auth/user_model.dart';
import 'package:kaam_fast/model/worker/wallet_model.dart';

abstract class WorkerDashboardState {}

class WorkerDashboardInitial extends WorkerDashboardState {}

class WorkerDashboardLoading extends WorkerDashboardState {}

class WorkerDashboardLoaded extends WorkerDashboardState {
  final UserModel worker;
  final WalletModel wallet;
  final bool onDuty;

  WorkerDashboardLoaded({
    required this.worker,
    required this.wallet,
    required this.onDuty,
  });

  WorkerDashboardLoaded copyWith({
    UserModel? worker,
    WalletModel? wallet,
    bool? onDuty,
  }) {
    return WorkerDashboardLoaded(
      worker: worker ?? this.worker,
      wallet: wallet ?? this.wallet,
      onDuty: onDuty ?? this.onDuty,
    );
  }
}

class WorkerDashboardFailure extends WorkerDashboardState {
  final String errorMessage;
  WorkerDashboardFailure({required this.errorMessage});
}
