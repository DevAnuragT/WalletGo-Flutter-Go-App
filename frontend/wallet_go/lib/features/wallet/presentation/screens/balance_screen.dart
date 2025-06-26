import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/balance_provider.dart';

class BalanceScreen extends StatefulWidget {
  final String uid;
  const BalanceScreen({super.key, required this.uid});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<BalanceProvider>(context, listen: false).fetchBalance(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BalanceProvider>(context);

    final progress = provider.savingsGoal == 0
        ? 0.0
        : provider.balance / provider.savingsGoal;

    return Scaffold(
      appBar: AppBar(title: const Text("My Wallet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Balance: ₹${provider.balance}", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
            const SizedBox(height: 10),
            Text("Goal: ₹${provider.savingsGoal}"),
            const SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Update Savings Goal"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final goal = int.tryParse(_goalController.text);
                if (goal != null) {
                  provider.updateGoal(widget.uid, goal);
                }
              },
              child: const Text("Update Goal"),
            )
          ],
        ),
      ),
    );
  }
}