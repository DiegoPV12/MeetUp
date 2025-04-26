import 'package:flutter/material.dart';

class EventCategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onChanged;

  const EventCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Categoría',
      ),
      items: const [
        DropdownMenuItem(value: 'birthday', child: Text('Cumpleaños')),
        DropdownMenuItem(value: 'get-together', child: Text('Junte')),
        DropdownMenuItem(value: 'party', child: Text('Fiesta')),
        DropdownMenuItem(value: 'wedding', child: Text('Boda')),
        DropdownMenuItem(value: 'reunion', child: Text('Reunión Familiar')),
      ],
      onChanged: onChanged,
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'La categoría es obligatoria'
                  : null,
    );
  }
}
