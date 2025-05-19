// lib/views/guest_list_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/home/section_title.dart';
import 'package:provider/provider.dart';
import '../models/guest_model.dart';
import '../viewmodels/guest_viewmodel.dart';
import '../widgets/guests/guest_tile.dart';
import '../widgets/guests/guest_form_bottom_sheet.dart';
import '../theme/theme.dart';

class GuestListView extends StatelessWidget {
  final String eventId;
  const GuestListView({super.key, required this.eventId});

  static const _statuses = ['all', 'pending', 'confirmed', 'declined'];

  static const _labels = {
    'all': 'Todos',
    'pending': 'Pendiente',
    'confirmed': 'Confirmado',
    'declined': 'Rechazado',
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuestViewModel()..loadGuests(eventId),
      child: Scaffold(
        appBar: AppBar(title: const SectionTitle('Invitados')),
        floatingActionButton: Consumer<GuestViewModel>(
          builder:
              (_, vm, __) => FloatingActionButton(
                onPressed:
                    () =>
                        showGuestFormBottomSheet(context, vm, eventId: eventId),
                child: const Icon(Icons.add),
              ),
        ),
        body: Consumer<GuestViewModel>(
          builder: (ctx, vm, __) {
            return Column(
              children: [
                const SizedBox(height: Spacing.spacingMedium),
                // — buscador —
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacingLarge,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Buscar invitado...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: vm.updateSearchTerm,
                  ),
                ),
                const SizedBox(height: Spacing.spacingSmall),
                // — filtros en chips —
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacingLarge,
                  ),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _statuses.map((status) {
                          final selected = vm.currentFilter == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(_labels[status]!),
                              selected: selected,
                              onSelected: (_) => vm.updateStatusFilter(status),
                              selectedColor:
                                  Theme.of(ctx).colorScheme.primaryContainer,
                              backgroundColor:
                                  Theme.of(
                                    ctx,
                                  ).colorScheme.surfaceContainerHighest,
                              labelStyle: TextStyle(
                                color:
                                    selected
                                        ? Theme.of(
                                          ctx,
                                        ).colorScheme.onPrimaryContainer
                                        : Theme.of(
                                          ctx,
                                        ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: Spacing.spacingMedium),
                // — lista principal —
                Expanded(
                  child:
                      vm.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : vm.guests.isEmpty
                          ? const Center(
                            child: Text('No se encontraron invitados'),
                          )
                          : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.spacingLarge,
                            ),
                            itemCount: vm.guests.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final guest = vm.guests[i];
                              return ExpandableGuestTile(
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
                                onInvite: () {
                                  // TODO: implementar envío de invitación
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
