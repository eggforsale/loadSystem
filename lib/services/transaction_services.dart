/*import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService();
});

class TransactionService {
  late final Future<Isar> _isar;

  TransactionService() {
    _isar = _initializeDatabase();
  }

  Future<Isar> _initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [LoadProductSchema, TransactionSchema],
      directory: dir.path,
    );
  }

  Future<List<Transaction>> getTransactions() async {
    final isar = await _isar;
    return await isar.transactions.where().findAll();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }
}
*/