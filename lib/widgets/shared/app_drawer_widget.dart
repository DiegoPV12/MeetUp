import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
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

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userViewModel.user?.name ?? 'Usuario'),
            accountEmail: Text(userViewModel.user?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              final rootContext = Navigator.of(context).context;

              final shouldLogout = await _showLogoutConfirmation(rootContext);
              if (shouldLogout) {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(milliseconds: 300));
                await authViewModel.logout();
                Navigator.pushNamedAndRemoveUntil(
                  rootContext,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Lista de eventos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/events');
            },
          ),
        ],
      ),
    );
  }
}
