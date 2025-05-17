import 'package:flutter/material.dart';
import '../../../models/guest_model.dart';

class GuestTile extends StatelessWidget {
  final GuestModel guest;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<String> onStatusChange;

  const GuestTile({
    super.key,
    required this.guest,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    required this.onStatusChange,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'declined':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmado';
      case 'declined':
        return 'Rechazado';
      default:
        return 'Pendiente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(guest.status);
    final statusLabel = _getStatusLabel(guest.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(index.toString()),
        ),
        title: Text(
          guest.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(guest.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: statusColor),
                const SizedBox(width: 6),
                Text(statusLabel, style: TextStyle(color: statusColor)),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'Opciones',
          onSelected: onStatusChange,
          icon: const Icon(Icons.more_vert),
          itemBuilder:
              (ctx) => [
                PopupMenuItem(
                  value: 'pending',
                  child: Row(
                    children: const [
                      Icon(Icons.hourglass_empty, size: 18),
                      SizedBox(width: 8),
                      Text('Pendiente'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'confirmed',
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle, size: 18),
                      SizedBox(width: 8),
                      Text('Confirmado'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'declined',
                  child: Row(
                    children: const [
                      Icon(Icons.cancel, size: 18),
                      SizedBox(width: 8),
                      Text('Rechazado'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: onEdit,
                  child: Row(
                    children: const [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: onDelete,
                  child: Row(
                    children: const [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }
}
