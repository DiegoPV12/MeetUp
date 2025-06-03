// importaciones…
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/activity_viewmodel.dart';
import '../widgets/activities/activity_form_bottom_sheet.dart';
import '../widgets/activities/activity_timeline.dart';

class ActivityListView extends StatelessWidget {
  final String eventId;
  const ActivityListView({super.key, required this.eventId});

  Future<bool> _confirmDelete(BuildContext context) async {
    final res =
        await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Confirmar eliminación'),
                content: const Text(
                  '¿Estás seguro de que deseas eliminar esta actividad?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityViewModel()..load(eventId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cronograma')),
        floatingActionButton: Consumer<ActivityViewModel>(
          builder:
              (_, vm, __) => FloatingActionButton(
                onPressed:
                    () => showActivityFormBottomSheet(
                      context,
                      vm,
                      eventId: eventId,
                    ),
                child: const Icon(Icons.add),
              ),
        ),
        body: Consumer<ActivityViewModel>(
          builder: (ctx, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.activities.isEmpty) {
              return const Center(child: Text('No hay actividades aún'));
            }

            // Ordenar cronológicamente
            final acts = [...vm.activities]
              ..sort((a, b) => a.startTime.compareTo(b.startTime));

            return ActivityTimeline(
              activities: acts,
              onEdit:
                  (act) => showActivityFormBottomSheet(
                    context,
                    vm,
                    eventId: eventId,
                    existing: act,
                  ),
              onDelete: (act) async {
                if (await _confirmDelete(context)) {
                  await vm.remove(act.id, eventId);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
