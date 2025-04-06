import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';

class TransactionsScreen extends StatelessWidget {
  final int userId;

  const TransactionsScreen({super.key, required this.userId});

  Future<List<Transaction>> fetchTransactions() async {
    return await isar.transactions
        .filter()
        .userIdEqualTo(userId)
        .sortByDateDesc()
        .findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Transaction>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No transaction history yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            );
          }

          final transactions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final txn = transactions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ₱${txn.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Provider: ${txn.selectedItem}'),
                    Text('Mobile: ${txn.mobileNumber}'),
                    Text('Date: ${txn.date.toLocal()}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
