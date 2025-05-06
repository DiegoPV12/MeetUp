// lib/views/edit_event_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/viewmodels/edit_event_viewmodel.dart';

import 'package:meetup/widgets/create_event/event_category_dropdown.dart';
import 'package:meetup/widgets/create_event/event_image_selector.dart';
import 'package:meetup/widgets/create_event/event_datetime_picker.dart';
import 'package:meetup/widgets/create_event/event_message_helper.dart';
import 'package:meetup/widgets/event_details/section_header.dart';
import 'package:meetup/widgets/home/section_title.dart';

class EditEventView extends StatelessWidget {
  final String eventId;
  const EditEventView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditEventViewModel>(
      create: (_) => EditEventViewModel()..loadEvent(eventId),
      child: const _EditEventScreen(),
    );
  }
}

/*───────────────────────────────────────────────────────────────────────────*/

class _EditEventScreen extends StatefulWidget {
  const _EditEventScreen();

  @override
  State<_EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<_EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl, _descCtrl, _locCtrl;

  String? _category, _image;
  DateTime? _date;
  TimeOfDay? _start, _end;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final e = context.read<EditEventViewModel>().event;
    if (!_init && e != null) {
      _nameCtrl = TextEditingController(text: e.name);
      _descCtrl = TextEditingController(text: e.description);
      _locCtrl = TextEditingController(text: e.location);
      _category = e.category;
      _image = e.imageUrl;
      _date = e.startTime;
      _start = TimeOfDay.fromDateTime(e.startTime);
      _end = e.endTime != null ? TimeOfDay.fromDateTime(e.endTime!) : null;
      _init = true;
    }
  }

  /*──────────────────────────  UI  ──────────────────────────*/

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditEventViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const SectionTitle('Editar Evento'),
        leading: BackButton(color: Theme.of(context).colorScheme.onBackground),
      ),
      body:
          (vm.isLoading || !_init)
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.horizontalMargin,
                  vertical: Spacing.verticalMargin,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*── Detalles ──────────────────────────────*/
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del evento',
                          hintText: 'Ej: Fiesta de Bienvenida',
                        ),
                        validator:
                            (v) => v!.trim().isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: Spacing.spacingLarge),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          hintText: 'Describe tu evento brevemente',
                        ),
                        validator:
                            (v) => v!.trim().isEmpty ? 'Requerido' : null,
                      ),

                      const SizedBox(height: Spacing.spacingLarge),

                      /*── Ubicación + Categoría ─────────────────*/
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _locCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Ubicación',
                                hintText: 'Ej: Av. Principal #123',
                              ),
                              validator:
                                  (v) => v!.trim().isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: Spacing.spacingMedium),
                          Expanded(
                            flex: 3,
                            child: EventCategoryDropdown(
                              selectedCategory: _category,
                              onChanged: (v) => setState(() => _category = v),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Spacing.spacingXLarge),

                      /*── Imagen ───────────────────────────────*/
                      const SectionHeader('Imagen'),
                      EventImageSelector(
                        selectedImage: _image,
                        onImageSelected: (v) => setState(() => _image = v),
                      ),

                      const SizedBox(height: Spacing.spacingXXLarge),

                      /*── Fecha y hora  (nuevo componente) ─────*/
                      const SectionHeader('Fecha y hora'),
                      const SizedBox(height: Spacing.spacingMedium),
                      EventDateTimePicker(
                        selectedDate: _date,
                        startTime: _start,
                        endTime: _end,
                        onDatePicked: (d) => setState(() => _date = d),
                        onStartTimePicked: (t) => setState(() => _start = t),
                        onEndTimePicked: (t) => setState(() => _end = t),
                      ),

                      const SizedBox(height: Spacing.spacingXLarge),

                      /*── Botones ──────────────────────────────*/
                      _buildButtons(context),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _onSave(context),
            icon: const Icon(Icons.save),
            label: const Text('Actualizar Evento'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.spacingMedium,
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.spacingMedium),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.spacingMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*────────────────────────  Guardar  ───────────────────────*/

  Future<void> _onSave(BuildContext ctx) async {
    if (!_formKey.currentState!.validate() ||
        _date == null ||
        _start == null ||
        _category == null ||
        _image == null) {
      showMessage(ctx, 'Completa todos los campos', isError: true);
      return;
    }

    final startDt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _start!.hour,
      _start!.minute,
    );

    DateTime? endDt;
    if (_end != null) {
      endDt = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _end!.hour,
        _end!.minute,
      );
      if (endDt.isBefore(startDt)) {
        showMessage(ctx, 'La hora de fin debe ser después', isError: true);
        return;
      }
    }

    try {
      final vm = context.read<EditEventViewModel>();
      final id = vm.event!.id;
      await vm.updateEvent(id, {
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'location': _locCtrl.text.trim(),
        'category': _category!,
        'startTime': startDt.toIso8601String(),
        'endTime': endDt?.toIso8601String(),
        'imageUrl': _image!,
      });
      showMessage(ctx, 'Evento actualizado');
      Navigator.pop(ctx, true);
    } catch (_) {
      showMessage(ctx, 'Error al actualizar', isError: true);
    }
  }
}
