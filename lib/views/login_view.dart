import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'MeetUp',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El email es obligatorio';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Ingresa un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    if (value.trim().length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await viewModel.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              Navigator.pushReplacementNamed(context, '/home');
                            } catch (e) {
                              _showError(context, 'Error al iniciar sesión');
                            }
                          }
                        },
                        child: const Text('Iniciar sesión'),
                      ),
                    ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('¿No tienes cuenta? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
