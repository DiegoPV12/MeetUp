import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetup/viewmodels/collaborator_viewmodel.dart';

class CollaboratorView extends StatefulWidget {
  final String eventId;
  final String creatorId;

  const CollaboratorView({
    super.key,
    required this.eventId,
    required this.creatorId,
  });

  @override
  State<CollaboratorView> createState() => _CollaboratorViewState();
}

class _CollaboratorViewState extends State<CollaboratorView> {
  late CollaboratorViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = CollaboratorViewModel();
    _vm.init(widget.eventId, widget.creatorId);
  }

  /// Muestra el diálogo para agregar un nuevo colaborador
  void _showAddDialog() {
    String searchQuery = '';

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: _vm,
          child: StatefulBuilder(
            builder: (context, setState) {
              final vm = Provider.of<CollaboratorViewModel>(context);
              final filtered =
                  vm.availableUsers.where((u) {
                    final q = searchQuery.toLowerCase();
                    return u.name.toLowerCase().contains(q) ||
                        u.email.toLowerCase().contains(q);
                  }).toList();

              // Calculamos un alto al 70% de la pantalla
              final maxHeight = MediaQuery.of(context).size.height * 0.7;
              final cs = Theme.of(context).colorScheme;

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: SizedBox(
                  height: maxHeight,
                  child: Column(
                    children: [
                      // Encabezado con degradado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [cs.primary, cs.primary.withAlpha(200)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Agregar colaborador',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Campo de búsqueda
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar por nombre o email',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() => searchQuery = value);
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Aquí ya hay un alto limitado, así que Expanded funciona
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child:
                              filtered.isEmpty
                                  ? const Center(child: Text('Sin resultados'))
                                  : ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder:
                                        (_, __) => const Divider(height: 0),
                                    itemBuilder: (context, index) {
                                      final user = filtered[index];
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 12,
                                            ),
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: cs.primaryContainer,
                                          child: Text(
                                            user.name.isNotEmpty
                                                ? user.name[0].toUpperCase()
                                                : '?',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: cs.primary,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          user.email,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.person_add,
                                            color: cs.primary,
                                          ),
                                          tooltip: 'Agregar',
                                          onPressed: () async {
                                            try {
                                              await vm.addCollaborator(user);
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Error al agregar: $e',
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ),

                      // Botón Cerrar
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, bottom: 12),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cerrar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<CollaboratorViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Colaboradores')),
            body:
                vm.sortedCollaborators.isEmpty
                    ? const Center(child: Text('Sin colaboradores'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      itemCount: vm.sortedCollaborators.length,
                      itemBuilder: (context, index) {
                        final user = vm.sortedCollaborators[index];
                        // Dismissible para swipe-to-delete:
                        return Dismissible(
                          key: ValueKey(user.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red.shade400,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            // Mostrar confirmación antes de borrar
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text('Quitar colaborador'),
                                    content: Text('¿Eliminar a ${user.name}?'),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(ctx).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(ctx).pop(true),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                            );
                            return confirm == true;
                          },
                          onDismissed: (_) async {
                            // En el Dismissible, llamamos a removeCollaborator
                            try {
                              await vm.removeCollaborator(user);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al eliminar: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: cs.primaryContainer,
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.redAccent,
                                  size: 24,
                                ),
                                tooltip: 'Eliminar colaborador',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (ctx) => AlertDialog(
                                          title: const Text(
                                            'Quitar colaborador',
                                          ),
                                          content: Text(
                                            '¿Eliminar a ${user.name}?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    ctx,
                                                  ).pop(false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    ctx,
                                                  ).pop(true),
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    try {
                                      await vm.removeCollaborator(user);
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'No se pueden eliminar colaboradores con tareas asignadas.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            floatingActionButton: FloatingActionButton(
              onPressed: _showAddDialog,
              tooltip: 'Agregar colaborador',
              child: const Icon(Icons.person_add_alt_1),
            ),
          );
        },
      ),
    );
  }
}
