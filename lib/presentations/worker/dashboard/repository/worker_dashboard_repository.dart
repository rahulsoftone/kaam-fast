import 'package:kaam_fast/data/network/dio_client.dart';
import 'package:kaam_fast/model/auth/user_model.dart';
import 'package:kaam_fast/model/worker/wallet_model.dart';
import 'package:kaam_fast/services/storage_service.dart';
import 'package:kaam_fast/utils/constants/app_urls.dart';

class WorkerDashboardRepository {
  final DioClient _dioClient = DioClient();
  final StorageService _storageService = StorageService();

  Future<UserModel> getWorkerProfile() async {
    try {
      final res = await _dioClient.get(AppUrls.workerMe);
      if (res is Map<String, dynamic> && res['data'] is Map<String, dynamic>) {
        return UserModel.fromJson(res['data'] as Map<String, dynamic>, defaultRole: 'worker');
      }
    } catch (_) {}

    final onDuty = await _storageService.getDuty();
    return UserModel(
      id: 'wk_101',
      phone: '9876543210',
      name: 'Ramesh Kumar',
      onDuty: onDuty,
      kycStatus: 'approved',
      isTrained: true,
      rating: RatingModel(average: 4.9, count: 124),
    );
  }

  Future<bool> toggleDuty(bool onDuty) async {
    await _storageService.setDuty(onDuty);
    try {
      await _dioClient.post(AppUrls.workerDuty, data: {'on_duty': onDuty});
    } catch (_) {}
    return onDuty;
  }

  Future<WalletModel> getWallet() async {
    try {
      final res = await _dioClient.get(AppUrls.workerWallet);
      if (res is Map<String, dynamic> && res['data'] is Map<String, dynamic>) {
        return WalletModel.fromJson(res['data'] as Map<String, dynamic>);
      }
    } catch (_) {}

    return WalletModel(
      balancePaise: 45000, // ₹450 demo balance
      entries: [
        WalletEntryModel(
          id: '1',
          type: 'debit',
          amountPaise: 2500, // ₹25 platform fee
          description: 'Job Commission - Sector 62 Plumber',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        WalletEntryModel(
          id: '2',
          type: 'credit',
          amountPaise: 50000, // ₹500 recharge
          description: 'Cashfree Wallet Recharge (UPI)',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    );
  }
}
