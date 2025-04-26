import 'package:flutter/material.dart';
import 'package:meetup/views/widgets/app_drawer_widget.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: const AppDrawerWidget(),
      body: const Center(
        child: Text('¡Bienvenido a MeetUp!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
