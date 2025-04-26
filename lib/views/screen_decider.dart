import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/decider_viewmodel.dart';

class ScreenDecider extends StatefulWidget {
  const ScreenDecider({Key? key}) : super(key: key);

  @override
  State<ScreenDecider> createState() => _ScreenDeciderState();
}

class _ScreenDeciderState extends State<ScreenDecider> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final deciderViewModel = Provider.of<DeciderViewModel>(
      context,
      listen: false,
    );
    final isLoggedIn = await deciderViewModel.checkIfLoggedIn();

    if (isLoggedIn == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (isLoggedIn == false) {
      Navigator.pushReplacementNamed(context, '/');
    }
    // Si es null (error), no hacemos nada. El widget muestra botón de reintentar.
  }

  @override
  Widget build(BuildContext context) {
    final deciderViewModel = Provider.of<DeciderViewModel>(context);

    if (deciderViewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (deciderViewModel.hasError) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'No se pudo conectar con el servidor.\nVerifica tu conexión a internet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _decide,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
