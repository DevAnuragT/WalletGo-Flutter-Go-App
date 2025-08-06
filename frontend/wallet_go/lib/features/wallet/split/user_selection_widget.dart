import 'package:flutter/material.dart';

class UserSelectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final List<String> selectedUserIds;
  final void Function(List<String>) onSelectionChanged;

  const UserSelectionWidget({
    super.key,
    required this.users,
    required this.selectedUserIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: users.map((user) {
        final isSelected = selectedUserIds.contains(user['uid']);
        return FilterChip(
          label: Text(user['name']),
          avatar: CircleAvatar(child: Text(user['name'][0])),
          selected: isSelected,
          onSelected: (selected) {
            final updated = List<String>.from(selectedUserIds);
            if (selected) {
              updated.add(user['uid']);
            } else {
              updated.remove(user['uid']);
            }
            onSelectionChanged(updated);
          },
        );
      }).toList(),
    );
  }
}