import 'package:flutter/material.dart';
import 'package:meetup/viewmodels/auth_viewmodel.dart';
import 'package:meetup/viewmodels/decider_viewmodel.dart';
import 'package:meetup/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'views/screen_decider.dart';

void main() {
  runApp(const MeetUpApp());
}

class MeetUpApp extends StatelessWidget {
  const MeetUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => DeciderViewModel()),
      ],
      child: MaterialApp(
        title: 'MeetUp',
        debugShowCheckedModeBanner: false,
        initialRoute: '/decider',
        routes: {
          '/decider': (context) => const ScreenDecider(),
          '/': (context) => LoginView(),
          '/register': (context) => RegisterView(),
          '/home': (context) => const HomeView(),
        },
      ),
    );
  }
}
