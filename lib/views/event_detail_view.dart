import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_detail_viewmodel.dart';
import '../theme/theme.dart';
import '../widgets/event_details/event_header.dart';
import '../widgets/event_details/status_badge.dart';
import '../widgets/event_details/apptab.dart';
import '../widgets/event_details/detail_tab_section.dart';
import '../widgets/event_details/general_tab.dart';
import '../widgets/event_details/rsvp_tab.dart';
import '../widgets/event_details/budget_tab.dart';
import '../widgets/event_details/task_tab.dart';

class EventDetailView extends StatelessWidget {
  final String eventId;
  const EventDetailView({super.key, required this.eventId});

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    String message,
  ) async {
    return (await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Confirmar'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventDetailViewModel>(
      create: (_) => EventDetailViewModel()..fetchEventDetail(eventId),
      child: Scaffold(
        body: Consumer<EventDetailViewModel>(
          builder: (ctx, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.event == null) {
              return Center(
                child: Text(
                  'Error al cargar el evento',
                  style: Theme.of(ctx).textTheme.bodyLarge,
                ),
              );
            }

            final e = vm.event!;
            final cancelled = e.isCancelled ?? false;
            final imagePath =
                (e.imageUrl?.isNotEmpty ?? false)
                    ? 'assets/images/${e.imageUrl}'
                    : 'assets/images/4.png';

            return DefaultTabController(
              length: 4, // ← ahora son 4 pestañas
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EventHeader(imagePath: imagePath),
                  const SizedBox(height: Spacing.spacingMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.horizontalMargin,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.name,
                            style: Theme.of(ctx).textTheme.headlineMedium,
                          ),
                        ),
                        StatusBadge(cancelled),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.horizontalMargin,
                      Spacing.spacingSmall,
                      Spacing.horizontalMargin,
                      0,
                    ),
                    child: Text(
                      e.category[0].toUpperCase() + e.category.substring(1),
                      style: Theme.of(ctx).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.horizontalMargin,
                      Spacing.spacingLarge,
                      Spacing.horizontalMargin,
                      0,
                    ),
                    child: AppTabBar(
                      tabs: const [
                        Tab(icon: Icon(Icons.info_outline), text: 'General'),
                        Tab(icon: Icon(Icons.people_outline), text: 'RSVP'),
                        Tab(
                          icon: Icon(Icons.checklist_outlined), // nueva pestaña
                          text: 'Tareas',
                        ),
                        Tab(
                          icon: Icon(Icons.account_balance_wallet_outlined),
                          text: 'Presupuesto',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DetailTabSection(
                      views: [
                        GeneralTab(
                          description: e.description,
                          startTime: e.startTime,
                          endTime: e.endTime,
                          location: e.location,
                        ),
                        const RsvpTab(confirmed: 12, total: 20),
                        TaskTab(e.id),
                        BudgetTab(
                          eventId: e.id,
                          budget: e.budget ?? 0,
                          eventStartDate: e.startTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Consumer<EventDetailViewModel>(
          builder: (ctx, vm, _) {
            if (vm.event == null) return const SizedBox.shrink();
            final e = vm.event!;
            final cancelled = e.isCancelled ?? false;

            return SpeedDial(
              icon: Icons.menu,
              activeIcon: Icons.close,
              backgroundColor: Theme.of(ctx).colorScheme.primary,
              foregroundColor: Theme.of(ctx).colorScheme.onPrimary,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.edit),
                  label: 'Editar',
                  onTap: () async {
                    final updated = await Navigator.pushNamed(
                      ctx,
                      '/edit-event',
                      arguments: e.id,
                    );
                    if (updated == true) vm.fetchEventDetail(e.id);
                  },
                ),
                SpeedDialChild(
                  child: Icon(cancelled ? Icons.undo : Icons.cancel_outlined),
                  label: cancelled ? 'Reactivar' : 'Cancelar',
                  onTap: () async {
                    final ok = await _showConfirmationDialog(
                      ctx,
                      cancelled
                          ? '¿Reactivar este evento?'
                          : '¿Cancelar este evento?',
                    );
                    if (ok) {
                      await vm.toggleCancelEvent(
                        e.id,
                        isCurrentlyCancelled: cancelled,
                      );
                    }
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.delete),
                  label: 'Eliminar',
                  onTap: () async {
                    final ok = await _showConfirmationDialog(
                      ctx,
                      '¿Eliminar este evento? Esta acción no se puede deshacer.',
                    );
                    if (ok) {
                      await vm.deleteEvent(e.id);
                      Navigator.pop(ctx, true);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
