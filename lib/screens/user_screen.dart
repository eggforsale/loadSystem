import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:load_system/database/database.dart';
import 'package:load_system/models/models.dart';
import 'package:load_system/screens/about_screen.dart';
import 'package:load_system/screens/settings_screen.dart';
import 'package:load_system/screens/transactions_screen.dart';

class UserScreen extends StatefulWidget {
  final User user;

  const UserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  double balance = 0.0;
  String selectedProvider = 'TM';

  @override
  void initState() {
    super.initState();
    _loadUserBalance();
  }

  Future<void> _loadUserBalance() async {
    final user = await isar.users.filter().mobileNumberEqualTo(widget.user.mobileNumber).findFirst();
    if (user != null) {
      final balance = await isar.balances.filter().userIdEqualTo(user.id).findFirst();
      setState(() {
        this.balance = balance?.amount ?? 0.0;
      });
    }
  }

  void _onNavItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
        break;
    }
  }

  Future<void> _processLoad(double amount) async {
    final user = await isar.users.filter().mobileNumberEqualTo(widget.user.mobileNumber).findFirst();
    if (user == null) return;

    final userBalance = await isar.balances.filter().userIdEqualTo(user.id).findFirst();

    if (userBalance == null || userBalance.amount < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient balance!')),
      );
      return;
    }

    await isar.writeTxn(() async {
      userBalance.amount -= amount;
      await isar.balances.put(userBalance);

      await isar.transactions.put(Transaction()
        ..userId = widget.user.id
        ..amount = amount
        ..selectedItem = selectedProvider
        ..mobileNumber = widget.user.mobileNumber
        ..date = DateTime.now());
    });

    _loadUserBalance();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('₱$amount $selectedProvider')),
    );
  }

  void _showConfirmationDialog(double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Load'),
          content: Text('Are you sure you want to load ₱$amount to your $selectedProvider number?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processLoad(amount);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Widget _amountButton(double amount) {
    return ElevatedButton(
      onPressed: () => _showConfirmationDialog(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text('₱$amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Mobile Load'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionsScreen(userId: widget.user.id),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6.0, spreadRadius: 1.0),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Balance:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    '₱${balance.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedProvider,
              items: ['TM', 'SMART', 'TNT', 'GLOBE', 'GOMO', 'DITO'].map((provider) {
                return DropdownMenuItem(value: provider, child: Text(provider));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedProvider = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _amountButton(10),
                    _amountButton(20),
                    _amountButton(50),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _amountButton(50),
                    _amountButton(100),
                    _amountButton(200),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _amountButton(500),
                    _amountButton(1000),
                    _amountButton(2000),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
