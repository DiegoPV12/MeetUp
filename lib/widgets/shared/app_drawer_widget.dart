import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';

class AppDrawerWidget extends StatefulWidget {
  const AppDrawerWidget({super.key});

  @override
  State<AppDrawerWidget> createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends State<AppDrawerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).loadUserProfile();
    });
  }

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Cerrar sesión'),
                content: const Text('¿Estás seguro que quieres cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Cerrar sesión'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colorScheme.onPrimaryContainer,
                      foregroundColor: colorScheme.primaryContainer,
                      child: const Icon(Icons.person, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userViewModel.user?.name ?? 'Usuario',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userViewModel.user?.email ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                children: [
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Lista de eventos'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/events');
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: themeViewModel.isDarkMode,
                    onChanged: themeViewModel.toggleTheme,
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Modo oscuro'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  final rootContext = Navigator.of(context).context;

                  final shouldLogout =
                      await _showLogoutConfirmation(rootContext);
                  if (!context.mounted) return;
                  if (shouldLogout) {
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (!context.mounted) return;
                    await authViewModel.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      rootContext,
                      '/',
                      (route) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
