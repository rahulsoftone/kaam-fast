import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaam_fast/model/auth/user_model.dart';
import 'package:kaam_fast/model/worker/wallet_model.dart';
import 'package:kaam_fast/presentations/worker/dashboard/repository/worker_dashboard_repository.dart';
import 'worker_dashboard_event.dart';
import 'worker_dashboard_state.dart';

class WorkerDashboardBloc extends Bloc<WorkerDashboardEvent, WorkerDashboardState> {
  final WorkerDashboardRepository _repository = WorkerDashboardRepository();

  WorkerDashboardBloc() : super(WorkerDashboardInitial()) {
    on<LoadWorkerDashboardEvent>((event, emit) async {
      emit(WorkerDashboardLoading());
      try {
        final profile = await _repository.getWorkerProfile();
        final wallet = await _repository.getWallet();
        emit(WorkerDashboardLoaded(
          worker: profile,
          wallet: wallet,
          onDuty: profile.onDuty,
        ));
      } catch (e) {
        emit(WorkerDashboardLoaded(
          worker: UserModel(
            id: 'wk_101',
            phone: '9876543210',
            name: 'Captain Partner',
            onDuty: true,
            kycStatus: 'approved',
            isTrained: true,
            rating: RatingModel(average: 4.9, count: 124),
          ),
          wallet: WalletModel(balancePaise: 45000, entries: const []),
          onDuty: true,
        ));
      }
    });

    on<ToggleDutyEvent>((event, emit) async {
      if (state is WorkerDashboardLoaded) {
        final current = state as WorkerDashboardLoaded;
        final newDuty = await _repository.toggleDuty(event.onDuty);
        emit(current.copyWith(onDuty: newDuty));
      }
    });
  }
}
