import 'package:flutter/material.dart';
import 'transaction_filter_widget.dart';
import 'transaction_list_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Mock data for now
  List<Map<String, dynamic>> transactions = [
    {
      'id': '1',
      'amount': 120.0,
      'category': 'Food',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'Debit',
      'description': 'Lunch at Cafe',
    },
    {
      'id': '2',
      'amount': 200.0,
      'category': 'Shopping',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'Debit',
      'description': 'Clothes',
    },
    {
      'id': '3',
      'amount': 500.0,
      'category': 'Salary',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'Credit',
      'description': 'Monthly Salary',
    },
  ];

  // Filter state
  String? selectedCategory;
  String? selectedType;
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: Column(
        children: [
          TransactionFilterWidget(
            selectedCategory: selectedCategory,
            selectedType: selectedType,
            selectedDateRange: selectedDateRange,
            onFilterChanged: (category, type, dateRange) {
              setState(() {
                selectedCategory = category;
                selectedType = type;
                selectedDateRange = dateRange;
              });
            },
          ),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    // Apply filters to mock data
    List<Map<String, dynamic>> filtered = transactions.where((tx) {
      bool matchesCategory = selectedCategory == null || tx['category'] == selectedCategory;
      bool matchesType = selectedType == null || tx['type'] == selectedType;
      bool matchesDate = selectedDateRange == null ||
          (tx['date'].isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
              tx['date'].isBefore(selectedDateRange!.end.add(const Duration(days: 1))));
      return matchesCategory && matchesType && matchesDate;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No transactions found.'));
    }
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return TransactionListItem(transaction: filtered[index]);
      },
    );
  }
}
