import 'package:flutter/material.dart';
import '../../../models/guest_model.dart';

class GuestTile extends StatelessWidget {
  final GuestModel guest;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const GuestTile({
    super.key,
    required this.guest,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(guest.name),
      subtitle: Text('${guest.email} - Estado: ${guest.status.toUpperCase()}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
