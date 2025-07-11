import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_go/core/notifications/notification_service.dart';
import 'package:wallet_go/features/auth/presentation/screens/register_or_login_screen.dart';
import 'package:wallet_go/features/requests/presentation/providers/request_provider.dart';
import 'package:wallet_go/features/wallet/presentation/providers/split_provider.dart';
import 'package:wallet_go/features/wallet/presentation/providers/transaction_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/providers/auth_provider.dart';
import 'features/wallet/presentation/providers/wallet_provider.dart';
import 'firebase_options.dart';
import 'features/wallet/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  runApp(const WalletGoApp());
}

class WalletGoApp extends StatelessWidget {
  const WalletGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestsProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => SplitProvider()),

      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Wallet Go',
            theme: AppTheme.lightTheme,
            home: authProvider.isLoggedIn ? const HomeScreen() : const RegisterOrLoginScreen(),
          );
        },
      ),
    );
  }
}
