import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetup/viewmodels/edit_event_viewmodel.dart';
import 'package:meetup/widgets/create_event/event_category_dropdown.dart';
import 'package:meetup/widgets/create_event/event_datetime_picker.dart';
import 'package:meetup/widgets/create_event/event_image_selector.dart';
import 'package:meetup/widgets/create_event/event_message_helper.dart';

class EditEventView extends StatelessWidget {
  final String eventId;

  const EditEventView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditEventViewModel()..loadEvent(eventId),
      child: const _EditEventScreen(),
    );
  }
}

class _EditEventScreen extends StatefulWidget {
  const _EditEventScreen();

  @override
  State<_EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<_EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  String? _selectedCategory;
  String? _selectedImage;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<EditEventViewModel>(context);
    final event = viewModel.event;

    if (!_initialized && event != null) {
      _nameController = TextEditingController(text: event.name);
      _descriptionController = TextEditingController(text: event.description);
      _locationController = TextEditingController(text: event.location);
      _selectedCategory = event.category;
      _selectedImage = event.imageUrl;
      _selectedDate = event.startTime;
      _startTime = TimeOfDay.fromDateTime(event.startTime);
      _endTime =
          event.endTime != null ? TimeOfDay.fromDateTime(event.endTime!) : null;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditEventViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Evento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          viewModel.isLoading || !_initialized
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        _nameController,
                        'Nombre del Evento',
                        'Ej: Fiesta de Bienvenida',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _descriptionController,
                        'Descripción',
                        'Describe brevemente el evento',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _locationController,
                        'Ubicación',
                        'Ej: Av. Principal #123',
                      ),
                      const SizedBox(height: 16),
                      EventCategoryDropdown(
                        selectedCategory: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      EventDateTimePicker(
                        selectedDate: _selectedDate,
                        startTime: _startTime,
                        endTime: _endTime,
                        onDatePicked: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        onStartTimePicked: (time) {
                          setState(() {
                            _startTime = time;
                          });
                        },
                        onEndTimePicked: (time) {
                          setState(() {
                            _endTime = time;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      EventImageSelector(
                        selectedImage: _selectedImage,
                        onImageSelected: (value) {
                          setState(() {
                            _selectedImage = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _onUpdatePressed(context),
                          icon: const Icon(Icons.save),
                          label: const Text('Actualizar Evento'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Este campo es obligatorio'
                  : null,
    );
  }

  Future<void> _onUpdatePressed(BuildContext context) async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _startTime != null &&
        _selectedCategory != null &&
        _selectedImage != null) {
      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      DateTime? endDateTime;
      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
        if (endDateTime.isBefore(startDateTime)) {
          showMessage(
            context,
            'La hora de fin debe ser después de la hora de inicio',
            isError: true,
          );
          return;
        }
      }

      try {
        final eventId =
            Provider.of<EditEventViewModel>(context, listen: false).event!.id;

        await Provider.of<EditEventViewModel>(
          context,
          listen: false,
        ).updateEvent(eventId, {
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'location': _locationController.text.trim(),
          'category': _selectedCategory!,
          'startTime': startDateTime.toIso8601String(),
          'endTime': endDateTime?.toIso8601String(),
          'imageUrl': _selectedImage!,
        });

        if (!context.mounted) return;
        showMessage(context, 'Evento actualizado exitosamente');
        Navigator.pop(context, true); // <- retorna true al detalle
      } catch (e) {
        showMessage(context, 'Error al actualizar evento', isError: true);
      }
    } else {
      showMessage(
        context,
        'Completa todos los campos requeridos',
        isError: true,
      );
    }
  }
}
