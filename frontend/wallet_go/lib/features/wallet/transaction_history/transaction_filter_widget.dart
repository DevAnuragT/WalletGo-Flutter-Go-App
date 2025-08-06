import 'package:flutter/material.dart';

class TransactionFilterWidget extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedType;
  final DateTimeRange? selectedDateRange;
  final void Function(String?, String?, DateTimeRange?) onFilterChanged;

  const TransactionFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.selectedType,
    required this.selectedDateRange,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Category Dropdown
          DropdownButton<String>(
            hint: const Text('Category'),
            value: selectedCategory,
            items: const [
              DropdownMenuItem(value: 'Food', child: Text('Food')),
              DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
              DropdownMenuItem(value: 'Salary', child: Text('Salary')),
            ],
            onChanged: (value) => onFilterChanged(value, selectedType, selectedDateRange),
          ),
          const SizedBox(width: 8),
          // Type Dropdown
          DropdownButton<String>(
            hint: const Text('Type'),
            value: selectedType,
            items: const [
              DropdownMenuItem(value: 'Credit', child: Text('Credit')),
              DropdownMenuItem(value: 'Debit', child: Text('Debit')),
            ],
            onChanged: (value) => onFilterChanged(selectedCategory, value, selectedDateRange),
          ),
          const SizedBox(width: 8),
          // Date Range Picker
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDateRange: selectedDateRange,
                );
                if (picked != null) {
                  onFilterChanged(selectedCategory, selectedType, picked);
                }
              },
              child: Text(
                selectedDateRange == null
                    ? 'Date'
                    : '${selectedDateRange!.start.month}/${selectedDateRange!.start.day} - ${selectedDateRange!.end.month}/${selectedDateRange!.end.day}',
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Clear Filters Button
          if (selectedCategory != null || selectedType != null || selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear Filters',
              onPressed: () => onFilterChanged(null, null, null),
            ),
        ],
      ),
    );
  }
}
