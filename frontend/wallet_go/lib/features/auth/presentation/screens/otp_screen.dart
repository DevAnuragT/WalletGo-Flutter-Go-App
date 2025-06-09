import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../wallet/presentation/screens/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String name, email, phone;

  const OTPScreen({super.key, required this.name, required this.email, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();

  void _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) return;

    // TODO: Send POST request to backend: /verify-otp

    // Mock user creation for now
    final user = User(
      name: widget.name,
      email: widget.email,
      phone: widget.phone,
      balance: 1000,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _otpController, decoration: const InputDecoration(labelText: 'OTP')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _verifyOtp, child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}
