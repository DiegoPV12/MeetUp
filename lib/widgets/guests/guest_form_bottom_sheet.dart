import 'package:flutter/material.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import '../../../models/guest_model.dart';
import '../../../viewmodels/guest_viewmodel.dart';

void showGuestFormBottomSheet(
  BuildContext context,
  GuestViewModel vm, {
  required String eventId,
  GuestModel? existingGuest,
}) {
  final isEdit = existingGuest != null;

  final nameCtrl = TextEditingController(text: existingGuest?.name ?? '');
  final emailCtrl = TextEditingController(text: existingGuest?.email ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeader(isEdit ? 'Editar Invitado' : 'Nuevo Invitado'),
            const SizedBox(height: 12),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Actualizar' : 'Agregar'),
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final email = emailCtrl.text.trim();

                  if (name.isEmpty || email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nombre y email son obligatorios'),
                      ),
                    );
                    return;
                  }

                  final guest = GuestModel(
                    id: existingGuest?.id ?? '',
                    name: name,
                    email: email,
                    status: existingGuest?.status ?? 'pending',
                    eventId: eventId,
                  );

                  try {
                    if (isEdit) {
                      await vm.updateGuest(guest);
                    } else {
                      await vm.addGuest(guest);
                    }
                    if (!context.mounted) return;
                    Navigator.pop(ctx);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al guardar invitado'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
