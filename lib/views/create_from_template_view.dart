import 'package:flutter/material.dart';

class CreateFromTemplateView extends StatelessWidget {
  const CreateFromTemplateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear desde plantilla')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Elige una plantilla',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Aquí podrías navegar a la creación de evento precargado de Cumpleaños
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Plantilla Cumpleaños seleccionada'),
                  ),
                );
              },
              icon: const Icon(Icons.cake),
              label: const Text('Cumpleaños'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Aquí podrías navegar a la creación de evento precargado de Junte
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Plantilla Junte seleccionada')),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text('Junte'),
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
