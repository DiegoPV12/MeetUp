import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';
import 'package:meetup/theme/theme.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePwd = true;
  bool _obscureConfirm = true;

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Flecha atrás
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(color: cs.onSurface),
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

                  // Título
                  Text('Registrarse', style: tt.headlineLarge),

                  const SizedBox(height: Spacing.spacingLarge),

                  // Nombre
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nombre',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: cs.onSurface,
                      ),
                    ),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Obligatorio'
                                : null,
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

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
                        return 'Obligatorio';
                      }
                      final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!re.hasMatch(v.trim())) return 'Email inválido';
                      return null;
                    },
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

                  // Contraseña
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePwd,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: cs.onSurface),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePwd
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: cs.onSurface,
                        ),
                        onPressed:
                            () => setState(() => _obscurePwd = !_obscurePwd),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Obligatorio';
                      if (v.trim().length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

                  // Confirmar contraseña
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      hintText: 'Confirmar Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: cs.onSurface),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: cs.onSurface,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Obligatorio';
                      if (v.trim() != _passwordCtrl.text.trim()) {
                        return 'No coincide';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: Spacing.spacingXXLarge),

                  // ...
                  // Botón Registrar
                  FilledButton(
                    onPressed:
                        vm.isLoading
                            ? null
                            : () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await vm.register(
                                    _nameCtrl.text.trim(),
                                    _emailCtrl.text.trim(),
                                    _passwordCtrl.text.trim(),
                                  );
                                  _showSuccess(
                                    'Registro exitoso, inicia sesión',
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                  Navigator.pop(context);
                                } catch (_) {
                                  _showError('Error al registrar');
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
                                Text('Registrarse'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                  ),

                  const SizedBox(height: Spacing.spacingMedium),

                  // Texto final
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text.rich(
                        TextSpan(
                          text: '¿Ya tienes una cuenta? ',
                          style: tt.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Inicia Sesión',
                              style: tt.bodyMedium!.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
