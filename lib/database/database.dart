import 'package:isar/isar.dart';
import 'package:load_system/models/models.dart';
import 'package:path_provider/path_provider.dart';

late final Isar isar;

Future<void> setupIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([UserSchema, BalanceSchema, LoadProductSchema, UserFeedbackSchema, TransactionSchema], directory: dir.path);
}

Future<void> saveUser(String mobileNumber, String password, String role, double balance) async {
  await isar.writeTxn(() async {
    final user = User()
      ..mobileNumber = mobileNumber
      ..password = password
      ..role = role
      ..balance = balance;

    await isar.users.put(user);


    await isar.balances.put(Balance()..userId = user.id..amount = 0.0);
  });
}

Future<User?> getUser(String mobileNumber) async {
  return await isar.users.filter().mobileNumberEqualTo(mobileNumber).findFirst();
}

Future<double?> getBalance(int userId) async {
  final balance = await isar.balances.filter().userIdEqualTo(userId).findFirst();
  return balance?.amount;
}

Future<void> updateBalance(int userId, double newBalance) async {
  final balance = await isar.balances.filter().userIdEqualTo(userId).findFirst();
  if (balance != null) {
    balance.amount = newBalance;
    await isar.writeTxn(() async {
      await isar.balances.put(balance);
    });
  }
}

Future<void> saveFeedback(int userId, int rating, String comment) async {
  await isar.writeTxn(() async {
    await isar.userFeedbacks.put(UserFeedback()
      ..userId = userId
      ..rating = rating
      ..comment = comment
      ..date = DateTime.now());
  });
}

Future<List<UserFeedback>> getAllFeedbacks() async {
  return await isar.userFeedbacks.where().findAll();
}

Future<List<UserFeedback>> getUserFeedback(int userId) async {
  return await isar.userFeedbacks.filter().userIdEqualTo(userId).findAll();
}
