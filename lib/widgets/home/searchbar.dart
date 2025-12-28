// lib/views/widgets/home/search_bar_placeholder.dart
import 'package:flutter/material.dart';

class SearchBarPlaceholder extends StatelessWidget {
  const SearchBarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Buscar evento…',
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
