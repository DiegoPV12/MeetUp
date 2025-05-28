import 'package:flutter/material.dart';
import 'package:meetup/widgets/activities/activity_form_bottom_sheet.dart';
import 'package:meetup/widgets/activities/activity_tile.dart';
import 'package:provider/provider.dart';
import '../viewmodels/activity_viewmodel.dart';

class ActivityListView extends StatelessWidget {
  final String eventId;
  const ActivityListView({super.key, required this.eventId});

  Future<bool> _confirmDelete(BuildContext context) async {
    return (await showDialog<bool>(
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
        )) ??
        false;
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
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.activities.isEmpty) {
              return const Center(child: Text('No hay actividades aún'));
            }
            return ListView.builder(
              itemCount: vm.activities.length,
              itemBuilder: (_, i) {
                final a = vm.activities[i];
                return ActivityTile(
                  activity: a,
                  onDelete: () async {
                    final confirm = await _confirmDelete(context);
                    if (confirm) {
                      await vm.remove(a.id, eventId);
                    }
                  },
                  onEdit:
                      () => showActivityFormBottomSheet(
                        context,
                        vm,
                        eventId: eventId,
                        existing: a,
                      ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
