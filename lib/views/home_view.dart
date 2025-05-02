// lib/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/shared/app_drawer_widget.dart';
import 'package:meetup/widgets/shared/bottom_navbar.dart';
import 'package:meetup/widgets/home/searchbar.dart';
import 'package:meetup/widgets/home/section_title.dart';
import 'package:meetup/widgets/home/event_section.dart';
import 'package:meetup/widgets/home/action_card.dart';
import 'package:meetup/theme/theme.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventViewModel>(context, listen: false).fetchEvents();
    });
  }

  void _handleNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        // Ya estamos en Home
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        // TODO: ruta de notificaciones
        // Navigator.pushNamed(context, '/notifications');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final evm = Provider.of<EventViewModel>(context);

    return Scaffold(
      extendBody: true, // para que el BottomNavBar curve sobre el body
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('MeetUp', style: tt.headlineMedium),
        actions: [
          Builder(
            builder: (ctx) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.horizontalMargin,
            vertical: Spacing.verticalMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SearchBarPlaceholder(),
              const SizedBox(height: Spacing.spacingLarge),

              const SectionTitle('Próximos Eventos🎉'),
              const SizedBox(height: Spacing.spacingMedium),
              EventSection(isLoading: evm.isLoading, events: evm.events),
              const SizedBox(height: Spacing.spacingXLarge),

              ActionCard(
                title: 'Crea un Evento!',
                subtitle: 'Tus primeros pasos',
                buttonLabel: 'CREAR',
                onPressed:
                    () =>
                        Navigator.pushNamed(context, '/choose-event-creation'),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                imagePath: 'assets/images/create_event.png',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: _handleNavTap,
      ),
    );
  }
}
