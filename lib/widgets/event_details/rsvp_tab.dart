// lib/widgets/event_details/rsvp_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetup/viewmodels/guest_viewmodel.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import 'package:meetup/theme/theme.dart';

class RsvpTab extends StatefulWidget {
  final String eventId;
  const RsvpTab({super.key, required this.eventId});

  @override
  State<RsvpTab> createState() => _RsvpTabState();
}

class _RsvpTabState extends State<RsvpTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GuestViewModel>(
      create: (_) => GuestViewModel()..loadGuests(widget.eventId),
      child: Consumer<GuestViewModel>(
        builder: (ctx, vm, _) {
          final guests = [...vm.guests];

          final total = guests.length;
          final confirmedCount =
              guests.where((g) => g.status == 'confirmed').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader('RSVP'),
                const SizedBox(height: Spacing.spacingLarge),

                // Conteo: confirmados / total
                Center(
                  child: Text(
                    '$confirmedCount / $total confirmados',
                    style: Theme.of(ctx).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: Spacing.spacingXLarge),

                // Avatares
                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (guests.isEmpty)
                  Center(
                    child: Text(
                      'Aún no hay invitados',
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          guests.map((guest) {
                            final initials = _makeInitials(guest.name);
                            final bg = _statusColor(
                              guest.status,
                              // ignore: deprecated_member_use
                            ).withOpacity(0.2);
                            final fg = _statusColor(guest.status);
                            return Container(
                              margin: const EdgeInsets.only(
                                right: Spacing.spacingMedium,
                              ),
                              child: CircleAvatar(
                                radius: Spacing.spacingXLarge,
                                backgroundColor: bg,
                                child: Text(
                                  initials,
                                  style: Theme.of(
                                    ctx,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: fg,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                const SizedBox(height: Spacing.spacingXLarge),

                // Botón Ver Invitados
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      ctx,
                      '/guests',
                      arguments: widget.eventId,
                    ).then((_) => vm.loadGuests(widget.eventId));
                  },
                  child: const Text('Ver Invitados'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _makeInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green.shade700;
      case 'declined':
        return Colors.red.shade700;
      default:
        return Colors.orange.shade700; // pendiente
    }
  }
}
