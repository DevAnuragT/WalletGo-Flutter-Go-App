import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyPinScreen extends StatefulWidget {
  final VoidCallback onVerified;
  final String uid;
  const VerifyPinScreen({super.key, required this.onVerified, required this.uid});

  @override
  State<VerifyPinScreen> createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool isLoading = false;
  String? error;

  Future<void> verifyPin(String pin) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final res = await http.post(
      Uri.parse('http://localhost:8080/api/verify-pin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "uid": widget.uid,
        "pin": pin,
      }),
    );

    if (res.statusCode == 200) {
      widget.onVerified();
    } else {
      setState(() {
        error = "Invalid PIN";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Enter your 4-digit PIN to continue"),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: "PIN"),
            ),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : () => verifyPin(_pinController.text),
              child: isLoading ? const CircularProgressIndicator() : const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}