import 'package:flutter/material.dart';

class ChooseEventCreationView extends StatelessWidget {
  const ChooseEventCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Evento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Cómo deseas crear tu evento?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/create-event');
              },
              icon: const Icon(Icons.create),
              label: const Text('Desde cero'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/create-from-template');
              },
              icon: const Icon(Icons.format_shapes),
              label: const Text('Usar plantilla'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
