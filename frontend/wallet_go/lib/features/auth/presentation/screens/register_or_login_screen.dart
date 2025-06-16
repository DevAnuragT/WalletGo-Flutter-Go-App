import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/auth_provider.dart';
import 'otp_screen.dart';
import 'phone_entry_screen.dart';

class RegisterOrLoginScreen extends StatelessWidget {
  const RegisterOrLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Go - Sign In')),
      body: Center(
        child: authProvider.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
                onPressed: () async {
                  final result = await authProvider.signInWithGoogle();

                  if (!result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google Sign-in failed')),
                    );
                    return;
                  }

                  final exists = await authProvider.checkUserExistsInBackend();

                  if (exists) {
                    // ✅ Existing user → OTP screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtpScreen(phone: authProvider.phone, isLogin: true),
                      ),
                    );
                  } else {
                    // 🆕 New user → phone input screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PhoneEntryScreen()),
                    );
                  }
                },
              ),
      ),
    );
  }
}
