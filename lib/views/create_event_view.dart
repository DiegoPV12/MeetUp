import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_viewmodel.dart';
import 'widgets/create_event/create_event_form.dart';

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Evento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: CreateEventForm(eventViewModel: eventViewModel),
      ),
    );
  }
}
