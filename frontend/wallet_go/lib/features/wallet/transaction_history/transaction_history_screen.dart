import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_filter_widget.dart';
import 'transaction_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String? selectedCategory;
  String? selectedType;
  DateTimeRange? selectedDateRange;

  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() {
    setState(() {
      _transactionsFuture = TransactionService.fetchTransactions(
        category: selectedCategory,
        type: selectedType,
        dateRange: selectedDateRange,
      );
    });
  }

  void _onFilterChanged(String? category, String? type, DateTimeRange? dateRange) {
    selectedCategory = category;
    selectedType = type;
    selectedDateRange = dateRange;
    _fetchTransactions();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Column(
        children: [
          TransactionFilterWidget(
            selectedCategory: selectedCategory,
            selectedType: selectedType,
            selectedDateRange: selectedDateRange,
            onFilterChanged: _onFilterChanged,
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }
                final transactions = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        title: Text(
                          tx['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${tx['category'] ?? ''} • ${tx['type'] ?? ''}\n${_formatDate(tx['date']?.toString())}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        isThreeLine: true,
                        trailing: Text(
                          '\$${(tx['amount'] ?? 0).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: tx['type'] == 'Credit' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: tx['type'] == 'Credit'
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          child: Icon(
                            tx['type'] == 'Credit' ? Icons.arrow_downward : Icons.arrow_upward,
                            color: tx['type'] == 'Credit' ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
