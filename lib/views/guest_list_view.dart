import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/guest_model.dart';
import '../../viewmodels/guest_viewmodel.dart';
import '../widgets/guests/guest_tile.dart';
import '../widgets/guests/guest_form_bottom_sheet.dart';

class GuestListView extends StatelessWidget {
  final String eventId;
  const GuestListView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuestViewModel()..loadGuests(eventId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Invitados del Evento'),
          centerTitle: true,
        ),
        floatingActionButton: Consumer<GuestViewModel>(
          builder:
              (context, vm, _) => FloatingActionButton(
                onPressed:
                    () =>
                        showGuestFormBottomSheet(context, vm, eventId: eventId),
                child: const Icon(Icons.add),
              ),
        ),
        body: Consumer<GuestViewModel>(
          builder: (context, vm, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        isDense: true,
                        value: vm.currentFilter,
                        onChanged: (value) {
                          if (value != null) vm.updateStatusFilter(value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          prefixIcon: const Icon(Icons.filter_alt),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('Todos')),
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text('Pendiente'),
                          ),
                          DropdownMenuItem(
                            value: 'confirmed',
                            child: Text('Confirmado'),
                          ),
                          DropdownMenuItem(
                            value: 'declined',
                            child: Text('Rechazado'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Buscar...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                        onChanged: vm.updateSearchTerm,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child:
                      vm.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : vm.guests.isEmpty
                          ? const Center(
                            child: Text('No se encontraron invitados'),
                          )
                          : ListView.builder(
                            itemCount: vm.guests.length,
                            itemBuilder: (context, i) {
                              final guest = vm.guests[i];
                              return GuestTile(
                                guest: guest,
                                index: i + 1,
                                onDelete:
                                    () => vm.deleteGuest(guest.id, eventId),
                                onEdit:
                                    () => showGuestFormBottomSheet(
                                      context,
                                      vm,
                                      eventId: eventId,
                                      existingGuest: guest,
                                    ),
                                onStatusChange: (newStatus) async {
                                  final updated = GuestModel(
                                    id: guest.id,
                                    name: guest.name,
                                    email: guest.email,
                                    status: newStatus,
                                    eventId: guest.eventId,
                                  );
                                  await vm.updateGuest(updated);
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
