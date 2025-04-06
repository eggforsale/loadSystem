/*import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

final loadServiceProvider = Provider<LoadService>((ref) {
  return LoadService();
});

class LoadService {
  late final Future<Isar> _isar;

  LoadService() {
    _isar = _initializeDatabase();
  }

  Future<Isar> _initializeDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [LoadProductSchema, TransactionSchema],
      directory: dir.path,
    );
  }

  Future<List<LoadProduct>> getLoadProducts() async {
    final isar = await _isar;
    return await isar.loadProducts.where().findAll();
  }

  Future<void> addLoadProduct(LoadProduct product) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.loadProducts.put(product);
    });
  }
}
  
  */