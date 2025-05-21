import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/guest_viewmodel.dart';

class GuestActionsBar extends StatelessWidget {
  final String eventId;
  const GuestActionsBar({super.key, required this.eventId});

  Future<String?> _askForMessage(BuildContext context, String tipo) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Mensaje de $tipo'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                child: const Text('Enviar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GuestViewModel>(context, listen: false);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.email_outlined),
          tooltip: 'Enviar Invitaciones',
          onPressed: () async {
            final msg = await _askForMessage(context, 'invitación');
            if (msg != null) {
              try {
                await vm.sendInvitations(eventId, msg);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invitaciones enviadas')),
                  );
                }
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al enviar invitaciones')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_active_outlined),
          tooltip: 'Enviar Recordatorios',
          onPressed: () async {
            final msg = await _askForMessage(context, 'recordatorio');
            if (msg != null) {
              try {
                await vm.sendReminders(eventId, msg);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recordatorios enviados')),
                  );
                }
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al enviar recordatorios'),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
