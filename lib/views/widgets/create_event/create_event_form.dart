import 'package:flutter/material.dart';
import '../../../viewmodels/event_viewmodel.dart';
import 'event_category_dropdown.dart';
import 'event_datetime_picker.dart';
import 'event_message_helper.dart';

class CreateEventForm extends StatefulWidget {
  final EventViewModel eventViewModel;

  const CreateEventForm({super.key, required this.eventViewModel});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Nombre del Evento',
            hint: 'Ej: Fiesta de Bienvenida',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Descripción',
            hint: 'Describe brevemente el evento',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _locationController,
            label: 'Ubicación',
            hint: 'Ej: Av. Principal #123',
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
                _startTime = null;
                _endTime = null;
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
          const SizedBox(height: 32),
          widget.eventViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onCreateEventPressed,
                  icon: const Icon(Icons.check),
                  label: const Text('Crear Evento'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
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

  Future<void> _onCreateEventPressed() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null &&
        _selectedCategory != null) {
      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      final endDateTime = DateTime(
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

      try {
        await widget.eventViewModel.createEvent(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          category: _selectedCategory!,
          startTime: startDateTime,
          endTime: endDateTime,
        );
        showMessage(context, 'Evento creado exitosamente');
        Navigator.pushNamedAndRemoveUntil(context, '/events', (route) => false);
      } catch (e) {
        showMessage(context, 'Error al crear el evento', isError: true);
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
