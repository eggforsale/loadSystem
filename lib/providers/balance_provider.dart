import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:load_system/models/models.dart';
import '../database/database.dart';

final balanceProvider = StateNotifierProvider<BalanceNotifier, double>((ref) {
  return BalanceNotifier();
});

class BalanceNotifier extends StateNotifier<double> {
  BalanceNotifier() : super(0.0);

  Future<void> loadBalance(int userId) async {
    final balance = await isar.balances
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    state = balance?.amount ?? 0.0;
  }

  Future<void> deductBalance(int userId, double amount) async {
    final balance = await isar.balances
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    if (balance != null && balance.amount >= amount) {
      balance.amount -= amount;
      state = balance.amount;

      await isar.writeTxn(() async {
        await isar.balances.put(balance);
      });
    }
  }
}
