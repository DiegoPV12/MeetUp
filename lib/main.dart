import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:meetup/models/edit_budget_arguments.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/viewmodels/auth_viewmodel.dart';
import 'package:meetup/viewmodels/decider_viewmodel.dart';
import 'package:meetup/viewmodels/event_viewmodel.dart';
import 'package:meetup/viewmodels/task_viewmodel.dart';
import 'package:meetup/viewmodels/user_viewmodel.dart';
import 'package:meetup/views/choose_event_creation_view.dart';
import 'package:meetup/views/create_event_view.dart';
import 'package:meetup/views/create_from_template_view.dart';
import 'package:meetup/views/edit_event_view.dart';
import 'package:meetup/views/event_budget_view.dart';
import 'package:meetup/views/event_detail_view.dart';
import 'package:meetup/views/list_events_view.dart';
import 'package:meetup/views/task_list_view.dart';
import 'package:provider/provider.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'views/screen_decider.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MeetUpApp()));
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
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MaterialApp(
        // Device Preview settings
        builder: DevicePreview.appBuilder,
        useInheritedMediaQuery: true,

        theme: AppTheme.lightTheme,
        title: 'MeetUp',
        debugShowCheckedModeBanner: false,
        initialRoute: '/decider',
        routes: {
          '/decider': (context) => const ScreenDecider(),
          '/': (context) => LoginView(),
          '/register': (context) => RegisterView(),
          '/home': (context) => const HomeView(),
          '/choose-event-creation':
              (context) => const ChooseEventCreationView(),
          '/create-event': (context) => const CreateEventView(),
          '/create-from-template': (context) => const CreateFromTemplateView(),
          '/events': (context) => const ListEventsView(),
          '/event-detail': (context) {
            final eventId =
                ModalRoute.of(context)!.settings.arguments as String;
            return EventDetailView(eventId: eventId);
          },
          '/edit-event': (context) {
            final eventId =
                ModalRoute.of(context)!.settings.arguments as String;
            return EditEventView(eventId: eventId);
          },
          '/event-tasks': (context) {
            final eventId =
                ModalRoute.of(context)!.settings.arguments as String;
            return TaskBoardView(eventId: eventId);
          },
          '/budget': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as EditBudgetArguments;
            return EventBudgetView(
              eventId: args.eventId,
              currentBudget: args.currentBudget!,
            );
          },
        },
      ),
    );
  }
}
