import 'package:flutter/material.dart';
import '../../../../core/notifications/notification_service.dart';

class WalletProvider extends ChangeNotifier {
  int _balance = 10000; // Initial dummy balance
  final List<String> _transactions = [];

  int get balance => _balance;
  List<String> get transactions => List.unmodifiable(_transactions);

  void addPoints(int amount) {
    _balance += amount;
    _transactions.add("Credited ₹$amount");
    notifyListeners();
  }

  void subtractPoints(int amount) {
    _balance -= amount;
    _transactions.add("Debited ₹$amount");

    if (_balance < 100){
      NotificationService.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: "Low Balance Alert",
        body: "Your Wallet Go balance is below ₹50. Current: ₹$_balance",
      );
    }

    notifyListeners();
  }
}
