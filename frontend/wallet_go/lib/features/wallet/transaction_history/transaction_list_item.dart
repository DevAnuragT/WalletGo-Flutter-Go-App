import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          transaction['type'] == 'Credit' ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction['type'] == 'Credit' ? Colors.green : Colors.red,
        ),
        title: Text(transaction['description'] ?? ''),
        subtitle: Text('${transaction['category']} • ${_formatDate(transaction['date'])}'),
        trailing: Text(
          (transaction['type'] == 'Credit' ? '+' : '-') + '₹${transaction['amount'].toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction['type'] == 'Credit' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
