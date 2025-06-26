import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Request {
  final String id;
  final String from;
  final int amount;
  final String note;
  final String category;
  final String status;

  Request({required this.id, required this.from, required this.amount, required this.note, required this.category, required this.status});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      from: json['from'],
      amount: json['amount'],
      note: json['note'],
      category: json['category'],
      status: json['status'],
    );
  }
}

class RequestsProvider with ChangeNotifier {
  List<Request> _requests = [];
  bool _isLoading = false;

  List<Request> get requests => _requests;
  bool get isLoading => _isLoading;

  Future<void> fetchRequests(String uid) async {
    _isLoading = true;
    notifyListeners();

    final res = await http.get(Uri.parse('http://localhost:8080/api/requests?uid=$uid'));
    if (res.statusCode == 200) {
      final List decoded = json.decode(res.body);
      _requests = decoded.map((r) => Request.fromJson(r)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> respondToRequest(String requestId, String action) async {
    final res = await http.post(
      Uri.parse('http://localhost:8080/api/respond-request'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"request_id": requestId, "action": action}),
    );

    if (res.statusCode == 200) {
      _requests.removeWhere((r) => r.id == requestId);
      notifyListeners();
    }
  }
}
