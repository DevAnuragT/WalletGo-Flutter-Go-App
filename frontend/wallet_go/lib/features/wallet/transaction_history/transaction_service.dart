import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  static Future<List<Map<String, dynamic>>> fetchTransactions({
    String? category,
    String? type,
    DateTimeRange? dateRange,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (type != null) queryParams['type'] = type;
    if (dateRange != null) {
      queryParams['startDate'] = dateRange.start.toIso8601String();
      queryParams['endDate'] = dateRange.end.toIso8601String();
    }
    final uri = Uri.http(
      'localhost:8080', // Change to your backend host/port
      '/api/transactions',
      queryParams,
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}