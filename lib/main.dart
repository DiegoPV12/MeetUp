import 'package:flutter/material.dart';
import 'package:meetup/models/edit_budget_arguments.dart';
import 'package:meetup/theme/theme.dart';
import 'package:meetup/viewmodels/auth_viewmodel.dart';
import 'package:meetup/viewmodels/collaborator_viewmodel.dart';
import 'package:meetup/viewmodels/decider_viewmodel.dart';
import 'package:meetup/viewmodels/event_detail_viewmodel.dart';
import 'package:meetup/viewmodels/event_viewmodel.dart';
import 'package:meetup/viewmodels/expense_viewmodel.dart';
import 'package:meetup/viewmodels/task_viewmodel.dart';
import 'package:meetup/viewmodels/theme_viewmodel.dart';
import 'package:meetup/viewmodels/user_viewmodel.dart';
import 'package:meetup/views/activity_list_view.dart';
import 'package:meetup/views/choose_event_creation_view.dart';
import 'package:meetup/views/collaborator_list_view.dart';
import 'package:meetup/views/create_event_view.dart';
import 'package:meetup/views/create_from_template_view.dart';
import 'package:meetup/views/edit_event_view.dart';
import 'package:meetup/views/event_budget_view.dart';
import 'package:meetup/views/event_detail_view.dart';
import 'package:meetup/views/guest_list_view.dart';
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
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
        ChangeNotifierProvider(create: (_) => EventDetailViewModel()),
        ChangeNotifierProvider(create: (_) => CollaboratorViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.themeMode,
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
              '/create-event': (context) {
                final args =
                    ModalRoute.of(context)!.settings.arguments as String?;
                return CreateEventView(templateKey: args);
              },
              '/create-from-template':
                  (context) => const CreateFromTemplateView(),
              '/events': (context) => const ListEventsView(),
              '/event-detail': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map;
                return EventDetailView(
                  eventId: args['eventId'],
                  isCollaborator: args['isCollaborator'],
                );
              },
              '/edit-event': (context) {
                final eventId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return EditEventView(eventId: eventId);
              },
              '/event-tasks': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map;
                return TaskBoardView(
                  eventId: args['eventId'],
                  creatorId: args['creatorId'],
                );
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
              '/guests': (context) {
                final eventId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return GuestListView(eventId: eventId);
              },
              '/schedule': (context) {
                final eventId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return ActivityListView(eventId: eventId);
              },
              '/collaborators': (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map;
                return CollaboratorView(
                  eventId: args['eventId'],
                  creatorId: args['creatorId'],
                );
              },
            },
          );
        },
      ),
    );
  }
}
