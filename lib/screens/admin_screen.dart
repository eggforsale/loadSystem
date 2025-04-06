import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  late Future<List<UserFeedback>> _feedbacks;

  @override
  void initState() {
    super.initState();
    _feedbacks = getAllFeedbacks();
  }

  Future<void> _addBalanceToUser() async {
    final mobileNumber = _mobileController.text.trim();
    final amount = double.tryParse(_balanceController.text.trim());
    

    if (mobileNumber.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid mobile number and amount')),
      );
      return;
    }

    final user = await getUser(mobileNumber);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found')),
      );
      return;
    }

    var balance = await isar.balances.filter().userIdEqualTo(user.id).findFirst();

    print('Current balance: ${balance?.amount}');
    print('Adding amount: $amount');

    await isar.writeTxn(() async {
      if (balance != null) {
        balance.amount += amount;
        await isar.balances.put(balance);
      } else {
        await isar.balances.put(Balance()
          ..userId = user.id
          ..amount = amount);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('₱$amount added to ${user.mobileNumber}\'s balance.')),
    );

    _mobileController.clear();
    _balanceController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ADMIN')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add User Balance',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'User Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount to Add',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _addBalanceToUser,
                      child: Text('Add Balance'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<UserFeedback>>(
                  future: _feedbacks,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final feedbackList = snapshot.data!;
                    if (feedbackList.isEmpty) {
                      return Text('No feedback yet.');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Feedbacks',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        ...feedbackList.map((feedback) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text('Rating: ${feedback.rating} stars'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Comment: ${feedback.comment}'),
                                  Text('Date: ${feedback.date.toLocal()}'),
                                  Text('User ID: ${feedback.userId}',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        }
                        )
                        .toList(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
