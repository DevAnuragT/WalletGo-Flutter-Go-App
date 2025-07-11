import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetPinScreen extends StatefulWidget {
  final String uid;
  final VoidCallback onSuccess;
  const SetPinScreen({super.key, required this.uid, required this.onSuccess});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? error;
  bool isLoading = false;

  Future<void> setPin() async {
    final pin = _pinController.text;
    final confirm = _confirmPinController.text;

    if (pin.length != 4 || confirm.length != 4) {
      setState(() => error = "PIN must be 4 digits");
      return;
    }
    if (pin != confirm) {
      setState(() => error = "PINs do not match");
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    final res = await http.post(
      Uri.parse('http://localhost:8080/api/set-pin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"uid": widget.uid, "pin": pin}),
    );

    setState(() => isLoading = false);

    if (res.statusCode == 200) {
      widget.onSuccess(); // e.g., go to dashboard
    } else {
      setState(() => error = "Failed to set PIN");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Your PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Create a 4-digit PIN"),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: "PIN"),
            ),
            TextField(
              controller: _confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: "Confirm PIN"),
            ),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : setPin,
              child: isLoading ? const CircularProgressIndicator() : const Text("Save PIN"),
            )
          ],
        ),
      ),
    );
  }
}