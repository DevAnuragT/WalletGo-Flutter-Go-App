import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_go/features/requests/presentation/providers/request_provider.dart';

class RequestsScreen extends StatefulWidget {
  final String uid;
  const RequestsScreen({super.key, required this.uid});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RequestsProvider>(context, listen: false).fetchRequests(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Point Requests")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.requests.length,
              itemBuilder: (context, index) {
                final req = provider.requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text("From: ${req.from}"),
                    subtitle: Text("${req.note} - ₹${req.amount}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => provider.respondToRequest(req.id, 'accept'),
                          child: const Text("Accept"),
                        ),
                        TextButton(
                          onPressed: () => provider.respondToRequest(req.id, 'reject'),
                          child: const Text("Reject"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
