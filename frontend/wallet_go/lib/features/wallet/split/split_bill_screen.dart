import 'package:flutter/material.dart';
import 'user_selection_widget.dart';
import 'user_service.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  List<Map<String, dynamic>> users = [];
  List<String> selectedUserIds = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      users = await UserService.fetchUsers();
    } catch (e) {
      error = e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Split Bill')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text('Error: $error'))
                : Column(
                    children: [
                      UserSelectionWidget(
                        users: users,
                        selectedUserIds: selectedUserIds,
                        onSelectionChanged: (ids) {
                          setState(() {
                            selectedUserIds = ids;
                          });
                        },
                      ),
                      // ...existing split bill form fields...
                    ],
                  ),
      ),
    );
  }
}