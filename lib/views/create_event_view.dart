// lib/views/create_event_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/create_event/create_event_form.dart';
import 'package:provider/provider.dart';
import 'package:meetup/viewmodels/event_viewmodel.dart';

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventViewModel(),
      child: const CreateEventFormWrapper(),
    );
  }
}

class CreateEventFormWrapper extends StatelessWidget {
  const CreateEventFormWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EventViewModel>(context, listen: false);
    return CreateEventFormWizard(eventViewModel: vm);
  }
}
