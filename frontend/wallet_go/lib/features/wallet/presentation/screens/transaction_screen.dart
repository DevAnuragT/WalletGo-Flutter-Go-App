import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class TransactionsScreen extends StatefulWidget {
  final String uid;
  const TransactionsScreen({super.key, required this.uid});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactions(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final txn = provider.transactions[index];
                final isIncoming = txn.to == widget.uid;
                return ListTile(
                  leading: Icon(isIncoming ? Icons.call_received : Icons.call_made,
                      color: isIncoming ? Colors.green : Colors.red),
                  title: Text(isIncoming ? "From: ${txn.from}" : "To: ${txn.to}"),
                  subtitle: Text("${txn.note} • ${txn.category}"),
                  trailing: Text(
                    "${isIncoming ? "+" : "-"}₹${txn.amount}",
                    style: TextStyle(
                      color: isIncoming ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
