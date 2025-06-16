import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isLogin;

  const OtpScreen({super.key, required this.phone, required this.isLogin});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().sendOtp(widget.phone);
    });
  }

  void _verify() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();
      final success = await provider.verifyOtp(
        widget.phone,
        _otpController.text.trim(),
        widget.isLogin,
      );

      if (success && context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verification failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Enter OTP sent to your phone"),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'OTP'),
                validator: (val) =>
                    val == null || val.length != 6 ? "Invalid OTP" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _verify,
                child:
                    isLoading ? const CircularProgressIndicator() : const Text("Verify"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
