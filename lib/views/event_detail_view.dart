import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/event_detail_viewmodel.dart';

class EventDetailView extends StatelessWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    Future<bool> _showConfirmationDialog(
      BuildContext context,
      String message,
    ) async {
      return (await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Confirmar'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
          )) ??
          false;
    }

    return ChangeNotifierProvider(
      create: (_) => EventDetailViewModel()..fetchEventDetail(eventId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detalles del Evento')),
        body: Consumer<EventDetailViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.event == null) {
              return const Center(child: Text('Error al cargar evento'));
            }

            final event = viewModel.event!;
            final formattedStart = DateFormat(
              'yyyy-MM-dd hh:mm a',
            ).format(event.startTime);
            final formattedEnd =
                event.endTime != null
                    ? DateFormat('yyyy-MM-dd hh:mm a').format(event.endTime!)
                    : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/${event.imageUrl!}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image, size: 100),
                      ),
                  const SizedBox(height: 16),
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ubicación: ${event.location}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Categoría: ${event.category}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicio: $formattedStart',
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (formattedEnd != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Fin: $formattedEnd',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    (event.isCancelled ?? false)
                        ? 'Estado: Cancelado'
                        : 'Estado: Activo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          (event.isCancelled ?? false)
                              ? Colors.red
                              : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit-event',
                            arguments: event.id,
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await _showConfirmationDialog(
                            context,
                            event.isCancelled == true
                                ? '¿Deseas reactivar este evento?'
                                : '¿Deseas cancelar este evento?',
                          );
                          if (confirm) {
                            try {
                              await viewModel.toggleCancelEvent(
                                event.id,
                                isCurrentlyCancelled:
                                    event.isCancelled ?? false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    event.isCancelled == true
                                        ? 'Evento reactivado'
                                        : 'Evento cancelado',
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al actualizar estado'),
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(
                          event.isCancelled == true ? Icons.undo : Icons.cancel,
                        ),
                        label: Text(
                          event.isCancelled == true ? 'Reactivar' : 'Cancelar',
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await _showConfirmationDialog(
                            context,
                            '¿Deseas eliminar este evento? Esta acción no se puede deshacer.',
                          );
                          if (confirm) {
                            try {
                              await viewModel.deleteEvent(event.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Evento eliminado'),
                                ),
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/events',
                                (route) => false,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al eliminar evento'),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
