import 'package:isar/isar.dart';

part 'models.g.dart';

@collection
class LoadProduct {
  Id id = Isar.autoIncrement;
  late String name;
  late double price;
}

@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late int userId;
  late String selectedItem;
  late double amount;
  late DateTime date;
  late String mobileNumber;
}

@collection
class User {
  Id id = Isar.autoIncrement;
  late String mobileNumber;
  late String password;
  late String role;
  late double balance;
  
}

@collection
class Balance {
  Id id = Isar.autoIncrement;
  late int userId;
  late double amount;

  Balance();
  Balance.withValues({required this.userId, required this.amount});
}


@collection
class UserFeedback {
  Id id = Isar.autoIncrement;
  late int userId;
  late int rating;
  late String comment;
  late DateTime date;
}
