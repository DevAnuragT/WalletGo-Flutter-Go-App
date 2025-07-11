import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplitProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> sendSplitRequest({
    required String from,
    required List<String> recipients,
    required int totalAmount,
    required String note,
    required String category,
  }) async {
    _isLoading = true;
    notifyListeners();

    final res = await http.post(
      Uri.parse('http://localhost:8080/api/split-bill'), // change to live IP in prod
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "from": from,
        "recipients": recipients,
        "total_amount": totalAmount,
        "note": note,
        "category": category,
      }),
    );

    _isLoading = false;
    notifyListeners();

    return res.statusCode == 201;
  }
}
