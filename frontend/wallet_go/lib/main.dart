import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/wallet/presentation/providers/wallet_provider.dart';

void main() {
  runApp(const WalletGoApp());
}

class WalletGoApp extends StatelessWidget {
  const WalletGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(
        title: 'Wallet Go',
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
