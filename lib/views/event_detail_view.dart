import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:meetup/widgets/event_details/schedule_tab.dart';
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
  final bool isCollaborator;
  const EventDetailView({
    super.key,
    required this.eventId,
    required this.isCollaborator,
  });

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

  String _translateCategory(String key) {
    switch (key) {
      case 'birthday':
        return 'Cumpleaños';
      case 'get-together':
        return 'Junte';
      case 'party':
        return 'Fiesta';
      case 'wedding':
        return 'Boda';
      case 'reunion':
        return 'Reunión Familiar';
      default:
        return key; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventDetailViewModel>(
      create:
          (_) =>
              EventDetailViewModel()..fetchEventDetail(eventId, isCollaborator),
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
            final creatorId = e.createdBy;
            final cancelled = e.isCancelled ?? false;
            final imagePath =
                (e.imageUrl?.isNotEmpty ?? false)
                    ? 'assets/images/${e.imageUrl}'
                    : 'assets/images/4.png';

            return DefaultTabController(
              length: isCollaborator ? 2 : 5, // ← ahora son 4 pestañas
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EventHeader(
                    imagePath: imagePath,
                    eventId: eventId,
                    creatorId: creatorId,
                    isCollaborator: isCollaborator
                  ),
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
                      _translateCategory(e.category),
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
                      tabs: [
                        Tab(icon: Icon(Icons.info_outline), text: 'General'),
                        if (!isCollaborator)
                          Tab(icon: Icon(Icons.people_outline), text: 'RSVP'),
                        Tab(
                          icon: Icon(Icons.checklist_outlined),
                          text: 'Tareas',
                        ),
                        if (!isCollaborator)
                          Tab(
                            icon: Icon(Icons.account_balance_wallet_outlined),
                            text: 'Presupuesto',
                          ),
                        if (!isCollaborator)
                          Tab(icon: Icon(Icons.schedule), text: 'Cronograma'),
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
                        if (!isCollaborator) RsvpTab(eventId: eventId),
                        TaskTab(eventId: e.id, creatorId: e.createdBy),
                        if (!isCollaborator)
                          BudgetTab(eventId: e.id, eventStartDate: e.startTime),
                        if (!isCollaborator) ScheduleTab(e.id),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton:
            isCollaborator
                ? null
                : Consumer<EventDetailViewModel>(
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
                            if (updated == true) {
                              vm.fetchEventDetail(e.id, isCollaborator);
                            }
                          },
                        ),
                        SpeedDialChild(
                          child: Icon(
                            cancelled ? Icons.undo : Icons.cancel_outlined,
                          ),
                          label: cancelled ? 'Reactivar' : 'Cancelar',
                          onTap: () async {
                            final ok = await _showConfirmationDialog(
                              ctx,
                              cancelled
                                  ? '¿Reactivar este evento?'
                                  : '¿Cancelar este evento?',
                            );
                            if (!ctx.mounted) return;
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
                            if (!ctx.mounted) return;
                            if (ok) {
                              await vm.deleteEvent(e.id);
                              if (!ctx.mounted) return;
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
