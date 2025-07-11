import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplitProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

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
      Uri.parse('http://localhost:8080/api/split-bill'),
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

    if(res.statusCode == 201){
      await _showLocalNotification(
        'Split request sent',
        'You requested ₹$totalAmount split among ${recipients.length} users.',
      );
    }
    return res.statusCode == 201;
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'split_channel',
      'Split Requests',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(0, title, body, platformDetails);
  }

}
