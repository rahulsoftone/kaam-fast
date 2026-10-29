abstract class WorkerDashboardEvent {}

class LoadWorkerDashboardEvent extends WorkerDashboardEvent {}

class ToggleDutyEvent extends WorkerDashboardEvent {
  final bool onDuty;
  ToggleDutyEvent({required this.onDuty});
}
