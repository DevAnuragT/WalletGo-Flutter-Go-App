import 'package:flutter/material.dart';

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
    notifyListeners();
  }
}
