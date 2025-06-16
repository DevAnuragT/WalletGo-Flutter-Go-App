import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Go')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Balance: ₹${wallet.balance}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => wallet.addPoints(100),
                  child: const Text('Add ₹100'),
                ),
                ElevatedButton(
                  onPressed: () => wallet.subtractPoints(50),
                  child: const Text('Subtract ₹50'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: wallet.transactions.length,
                itemBuilder: (context, index) =>
                    ListTile(title: Text(wallet.transactions[index])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
