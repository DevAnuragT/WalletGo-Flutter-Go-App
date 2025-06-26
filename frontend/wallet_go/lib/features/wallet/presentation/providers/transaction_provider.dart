import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transaction {
  final String from;
  final String to;
  final int amount;
  final String note;
  final String category;
  final DateTime timestamp;

  Transaction({
    required this.from,
    required this.to,
    required this.amount,
    required this.note,
    required this.category,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      from: json['from'],
      to: json['to'],
      amount: json['amount'],
      note: json['note'],
      category: json['category'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> fetchTransactions(String uid) async {
    _isLoading = true;
    notifyListeners();

    final res = await http.get(Uri.parse('http://localhost:8080/api/transactions?uid=$uid'));

    if (res.statusCode == 200) {
      final List decoded = json.decode(res.body);
      _transactions = decoded.map((t) => Transaction.fromJson(t)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
