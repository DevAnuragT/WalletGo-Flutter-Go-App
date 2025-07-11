import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_go/features/auth/domain/providers/auth_provider.dart';
import 'package:wallet_go/features/wallet/presentation/providers/split_provider.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientsController = TextEditingController(); // comma-separated UIDs
  final _noteController = TextEditingController();
  final _categoryController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientsController.dispose();
    _noteController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final splitProvider = Provider.of<SplitProvider>(context, listen: false);

    final from = authProvider.uid;
    final recipients = _recipientsController.text.split(',').map((e) => e.trim()).toList();
    final totalAmount = int.tryParse(_amountController.text) ?? 0;

    setState(() => isSubmitting = true);
    final success = await splitProvider.sendSplitRequest(
      from: from,
      recipients: recipients,
      totalAmount: totalAmount,
      note: _noteController.text.trim(),
      category: _categoryController.text.trim(),
    );
    setState(() => isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Split request sent!')),
      );
      Navigator.pop(context); // go back
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Split Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null ? 'Enter a valid amount' : null,
              ),
              TextFormField(
                controller: _recipientsController,
                decoration: const InputDecoration(
                    labelText: 'Recipient UIDs (comma separated)'),
                validator: (value) => value == null || value.isEmpty ? 'Enter at least one recipient' : null,
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                child: isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Send Split Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
