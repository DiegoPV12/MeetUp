import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'package:meetup/theme/theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Spacing.horizontalMargin,
            Spacing.verticalMargin,
            Spacing.horizontalMargin,
            Spacing.spacingXXLarge * 2,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey, //
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Gorro
                  Center(
                    child: Image.asset(
                      'assets/images/partyhat.png',
                      width: 100,
                      height: 100,
                    ),
                  ),

                  const SizedBox(height: Spacing.spacingSmall),

                  // Título
                  Center(child: Text('MeetUp!', style: tt.headlineLarge)),

                  const SizedBox(height: Spacing.spacingSmall),

                  // Slogan
                  Text(
                    '¡Celebra a tu manera!',
                    style: tt.bodyLarge!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: Spacing.spacingXXLarge),

                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'abc@email.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: cs.onSurface,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'El email es obligatorio';
                      }
                      final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!re.hasMatch(v.trim())) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

                  // Contraseña
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: cs.onSurface,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: cs.onSurface,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      if (v.trim().length < 6) {
                        return 'Debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: Spacing.spacingXXLarge),

                  // Botón principal con spinner interno
                  FilledButton(
                    onPressed:
                        vm.isLoading
                            ? null
                            : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await vm.login(
                                    _emailCtrl.text.trim(),
                                    _passwordCtrl.text.trim(),
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                } catch (_) {
                                  _showError('Error al iniciar sesión');
                                }
                              }
                            },
                    child:
                        vm.isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('INICIAR SESIÓN'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

                  // Ir a registro
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/register'),
                        child: Text.rich(
                          TextSpan(
                            text: 'REGÍSTRATE',
                            style: tt.bodyMedium!.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Espacio extra abajo
                  const SizedBox(height: Spacing.spacingXXLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
