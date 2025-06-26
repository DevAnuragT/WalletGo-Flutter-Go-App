import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BalanceProvider with ChangeNotifier {
  int balance = 0;
  int savingsGoal = 0;

  Future<void> fetchBalance(String uid) async {
    final res = await http.get(Uri.parse('http://localhost:8080/api/user?uid=$uid'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      balance = data['balance'];
      savingsGoal = data['savingsGoal'] ?? 0;
      notifyListeners();
    }
  }

  Future<void> updateGoal(String uid, int goal) async {
    final res = await http.post(
      Uri.parse('http://localhost:8080/api/update-goal'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"uid": uid, "goal": goal}),
    );
    if (res.statusCode == 200) {
      savingsGoal = goal;
      notifyListeners();
    }
  }
}
