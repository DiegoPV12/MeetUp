// lib/views/create_event/create_event_form_wizard.dart
import 'package:flutter/material.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/viewmodels/event_viewmodel.dart';
import 'package:meetup/views/create_event_date_section.dart';
import 'package:meetup/views/create_event_details_section.dart';
import 'package:meetup/views/create_event_image_section.dart';
import 'package:meetup/views/create_event_location_section.dart';
import 'package:meetup/widgets/home/section_title.dart';

class CreateEventFormWizard extends StatefulWidget {
  final EventViewModel eventViewModel;
  const CreateEventFormWizard({super.key, required this.eventViewModel});

  @override
  State<CreateEventFormWizard> createState() => _CreateEventFormWizardState();
}

class _CreateEventFormWizardState extends State<CreateEventFormWizard> {
  // Paso actual
  int _step = 0;

  // FormKeys de secciones con TextFormFields
  final _formKeys = List<GlobalKey<FormState>>.generate(
    2,
    (_) => GlobalKey<FormState>(),
  );

  // Controladores / datos
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  String? _category;
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _image;

  final _stepLabels = const ['Detalles', 'Ubicación', 'Fecha y hora', 'Imagen'];

  // ---------- Navegación ----------
  void _next() {
    if (_step < 2 && !_formKeys[_step].currentState!.validate()) return;

    if (_step == 2 && (_date == null || _startTime == null)) {
      _showMsg('Selecciona fecha y hora de inicio');
      return;
    }

    if (_step == 3) {
      _submit();
      return;
    }
    setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  // ---------- Utilidades ----------
  void _showMsg(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _submit() async {
    if (_image == null) {
      _showMsg('Selecciona una imagen');
      return;
    }

    final start = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final end =
        _endTime != null
            ? DateTime(
              _date!.year,
              _date!.month,
              _date!.day,
              _endTime!.hour,
              _endTime!.minute,
            )
            : null;

    if (end != null && end.isBefore(start)) {
      _showMsg('La hora de fin debe ser después de la de inicio');
      return;
    }

    try {
      await widget.eventViewModel.createEvent(
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        location: _locCtrl.text.trim(),
        category: _category!,
        startTime: start,
        endTime: end,
        imageUrl: _image!,
      );
      _showMsg('Evento creado exitosamente');
      if (context.mounted) Navigator.pop(context, true);
    } catch (_) {
      _showMsg('Error al crear evento');
    }
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final pages = [
      DetailsSection(
        formKey: _formKeys[0],
        nameController: _nameCtrl,
        descriptionController: _descCtrl,
      ),
      LocationSection(
        formKey: _formKeys[1],
        locationController: _locCtrl,
        selectedCategory: _category,
        onCategoryChanged: (v) => setState(() => _category = v),
      ),
      DateTimeSection(
        selectedDate: _date,
        startTime: _startTime,
        endTime: _endTime,
        onDatePicked: (d) => setState(() => _date = d),
        onStartPicked: (t) => setState(() => _startTime = t),
        onEndPicked: (t) => setState(() => _endTime = t),
      ),
      ImageSection(
        selectedImage: _image,
        onImageSelected: (img) => setState(() => _image = img),
      ),
    ];

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const SectionTitle('Crear Evento')),
      body: SafeArea(
        child: Column(
          children: [
            // Indicador con texto
            Padding(
              padding: const EdgeInsets.all(Spacing.spacingMedium),
              child: Row(
                children: List.generate(_stepLabels.length, (i) {
                  final selected = i == _step;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: Spacing.spacingXSmall,
                          ),
                          color:
                              i <= _step
                                  ? cs.primary
                                  : cs.surfaceContainerHighest,
                        ),
                        const SizedBox(height: Spacing.spacingXSmall),
                        Text(
                          _stepLabels[i],
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.copyWith(
                            color: selected ? cs.primary : cs.onSurfaceVariant,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // Contenido de la sección actual
            Expanded(child: pages[_step]),

            // Botones navegación
            Padding(
              padding: const EdgeInsets.all(Spacing.spacingMedium),
              child: Row(
                children: [
                  if (_step > 0)
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(120, 48),
                      ),
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Atrás'),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 48),
                    ),
                    onPressed: _next,
                    icon: Icon(
                      _step == pages.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _step == pages.length - 1 ? 'Crear' : 'Siguiente',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
