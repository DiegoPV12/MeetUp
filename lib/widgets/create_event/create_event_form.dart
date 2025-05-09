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
  int _step = 0;

  final _formKeys = List<GlobalKey<FormState>>.generate(
    2,
    (_) => GlobalKey<FormState>(),
  );

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locCtrl = TextEditingController();

  String? _category;
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _image;

  final _stepLabels = const ['Detalles', 'Ubicación', 'Fecha y hora', 'Imagen'];

  /* ───────── navegación ───────── */
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

  /* ───────── util ───────── */
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
      _showMsg('Evento creado');
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/events',
        ModalRoute.withName('/home'),
      );
    } catch (_) {
      _showMsg('Error al crear evento');
    }
  }

  /* ───────── build ───────── */
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            /* indicador + texto */
            Padding(
              padding: const EdgeInsets.all(Spacing.spacingMedium),
              child: Row(
                children: List.generate(_stepLabels.length, (i) {
                  final sel = i == _step;
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
                            color: sel ? cs.primary : cs.onSurfaceVariant,
                            fontWeight:
                                sel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            /* contenido – envuelto en scroll para evitar overflow */
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: Spacing.spacingLarge),
                child: pages[_step],
              ),
            ),
          ],
        ),
      ),

      /* botones fijos, con padding que sigue el teclado */
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Spacing.spacingMedium,
            0,
            Spacing.spacingMedium,
            MediaQuery.of(context).viewInsets.bottom + Spacing.spacingMedium,
          ),
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
              if (_step == 0) const SizedBox(width: 120), // mantiene alineación
              const Spacer(),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(140, 48)),
                onPressed: _next,
                icon: Icon(
                  _step == pages.length - 1 ? Icons.check : Icons.arrow_forward,
                ),
                label: Text(_step == pages.length - 1 ? 'Crear' : 'Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
