import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_go/features/auth/domain/providers/auth_provider.dart';
import 'package:wallet_go/features/requests/presentation/providers/request_provider.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late String uid;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    uid = authProvider.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RequestsProvider>(context, listen: false).fetchRequests(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestsProvider = Provider.of<RequestsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Incoming Requests")),
      body: requestsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requestsProvider.requests.length,
              itemBuilder: (context, index) {
                final req = requestsProvider.requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text("₹${req.amount} from ${req.from}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Note: ${req.note}"),
                        Text("Category: ${req.category}"),
                        Text("Status: ${req.status}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            requestsProvider.respondToRequest(req.id, "accept");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            requestsProvider.respondToRequest(req.id, "reject");
                          },
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
