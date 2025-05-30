import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../viewmodels/guest_viewmodel.dart';
import 'guest_form_bottom_sheet.dart';
import 'guest_tile.dart';

class GuestListBody extends StatelessWidget {
  final String eventId;
  const GuestListBody({super.key, required this.eventId});

  static const _statuses = ['all', 'pending', 'confirmed', 'declined'];

  static const _labels = {
    'all': 'Todos',
    'pending': 'Pendiente',
    'confirmed': 'Confirmado',
    'declined': 'Rechazado',
  };

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GuestViewModel>(context);

    return Column(
      children: [
        const SizedBox(height: Spacing.spacingMedium),

        // — buscador —
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.spacingLarge),
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
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.spacingLarge),
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
                          Theme.of(context).colorScheme.primaryContainer,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(
                        color:
                            selected
                                ? Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer
                                : Theme.of(
                                  context,
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
                  ? const Center(child: Text('No se encontraron invitados'))
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacingLarge,
                    ),
                    itemCount: vm.guests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    // ───────────────── ListView de invitados ─────────────────
                    itemBuilder: (_, i) {
                      final guest = vm.guests[i];

                      return ExpandableGuestTile(
                        guest: guest,
                        index: i + 1,

                        onInvite: () async {
                          await vm.updateGuest(
                            guest.copyWith(
                              invitationSent: true,
                              updatedAt: DateTime.now(),
                            ),
                          );
                        },

                        onEdit:
                            () => showGuestFormBottomSheet(
                              context,
                              vm,
                              eventId: eventId,
                              existingGuest: guest,
                            ),

                        onDelete: () => vm.deleteGuest(guest.id, eventId),

                        onStatusChange: (newStatus) async {
                          final updated = guest.copyWith(
                            status: newStatus,
                            updatedAt: DateTime.now(),
                          );
                          await vm.updateGuest(updated);
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
