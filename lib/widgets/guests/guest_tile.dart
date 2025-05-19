// lib/widgets/guests/expandable_guest_tile.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/guests/circle_action.dart';
import '../../../models/guest_model.dart';

class ExpandableGuestTile extends StatefulWidget {
  final GuestModel guest;
  final int index;
  final VoidCallback onInvite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<String> onStatusChange;

  const ExpandableGuestTile({
    super.key,
    required this.guest,
    required this.index,
    required this.onInvite,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChange,
  });

  @override
  State<ExpandableGuestTile> createState() => _ExpandableGuestTileState();
}

class _ExpandableGuestTileState extends State<ExpandableGuestTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Color get _baseColor {
    switch (widget.guest.status) {
      case 'confirmed':
        return Colors.green.shade50;
      case 'declined':
        return Colors.red.shade50;
      default:
        return Colors.orange.shade50;
    }
  }

  Color get _borderColor {
    switch (widget.guest.status) {
      case 'confirmed':
        return Colors.green.shade200;
      case 'declined':
        return Colors.red.shade200;
      default:
        return Colors.orange.shade200;
    }
  }

  Color get _statusColor {
    switch (widget.guest.status) {
      case 'confirmed':
        return Colors.green.shade700;
      case 'declined':
        return Colors.red.shade700;
      default:
        return Colors.orange.shade700;
    }
  }

  String get _initials {
    final parts = widget.guest.name.trim().split(' ');
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts[1][0];
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _anim.forward() : _anim.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _baseColor,
        border: Border.all(color: _borderColor, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // ─── Header ───────────────────────
          InkWell(
            onTap: _toggle,
            child: Row(
              children: [
                // Avatar con iniciales
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _borderColor,
                  child: Text(
                    _initials.toUpperCase(),
                    style: tt.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Nombre y email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.guest.name, style: tt.headlineSmall),
                      const SizedBox(height: 2),
                      Text(widget.guest.email, style: tt.bodyMedium),
                    ],
                  ),
                ),

                // Índice
                Text(
                  '${widget.index}#',
                  style: tt.bodyLarge!.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),

                // Badge circular de estado
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 8),
                // icono expandir
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_anim),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),

          // ─── Acciones expandibles ───────────────────────
          SizeTransition(
            sizeFactor: _anim,
            axisAlignment: -1.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  // -- Fila de RSVP + Invitar --
                  Row(
                    children: [
                      if (widget.guest.status != 'pending')
                        CircleAction(
                          backgroundColor: Colors.orange.shade100,
                          icon: Icons.hourglass_bottom,
                          iconColor: Colors.orange.shade700,
                          onTap: () => widget.onStatusChange('pending'),
                        ),
                      if (widget.guest.status != 'confirmed')
                        CircleAction(
                          backgroundColor: Colors.green.shade100,
                          icon: Icons.check_circle,
                          iconColor: Colors.green.shade700,
                          onTap: () => widget.onStatusChange('confirmed'),
                        ),
                      if (widget.guest.status != 'declined')
                        CircleAction(
                          backgroundColor: Colors.red.shade100,
                          icon: Icons.cancel,
                          iconColor: Colors.red.shade700,
                          onTap: () => widget.onStatusChange('declined'),
                        ),

                      // empuja el botón Invitar al final
                      const Spacer(),

                      // Botón Invitar
                      InkWell(
                        onTap: widget.onInvite,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.send,
                            size: 20,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // -- Chips de Editar / Eliminar --
                  Row(
                    children: [
                      InputChip(
                        label: const Text('Editar'),
                        labelStyle: tt.labelSmall,
                        avatar: const Icon(Icons.edit, size: 16),
                        backgroundColor:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        onPressed: widget.onEdit,
                      ),
                      const SizedBox(width: 8),
                      InputChip(
                        label: const Text('Eliminar'),
                        labelStyle: tt.labelSmall!.copyWith(
                          color: Colors.red.shade800,
                        ),
                        avatar: Icon(
                          Icons.delete,
                          size: 16,
                          color: Colors.red.shade800,
                        ),
                        backgroundColor: Colors.red.shade100,
                        onPressed: () async {
                          final confirm =
                              await showDialog<bool>(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      title: const Text(
                                        'Confirmar eliminación',
                                      ),
                                      content: const Text(
                                        '¿Estás seguro de que quieres eliminar este invitado?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.of(ctx).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(ctx).pop(true),
                                          child: const Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              ) ??
                              false;

                          if (confirm) {
                            widget.onDelete();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
