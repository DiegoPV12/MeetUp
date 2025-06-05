// lib/views/list_events_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/models/event_model.dart';
import 'package:meetup/widgets/shared/dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:meetup/widgets/home/section_title.dart';
import 'package:meetup/widgets/home/next_event_card.dart';
import 'package:meetup/theme/theme.dart';
import '../viewmodels/event_viewmodel.dart';

class ListEventsView extends StatefulWidget {
  const ListEventsView({super.key});

  @override
  State<ListEventsView> createState() => _ListEventsViewState();
}

class _ListEventsViewState extends State<ListEventsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<EventViewModel>(context, listen: false);
      vm.fetchEvents();
      vm.fetchEventsAsCollaborator();
    });
  }

  Future<void> _refreshEvents() async {
    await Provider.of<EventViewModel>(context, listen: false).fetchEvents();
    await Provider.of<EventViewModel>(
      context,
      listen: false,
    ).fetchEventsAsCollaborator();
  }

  @override
  Widget build(BuildContext context) {
    final evm = Provider.of<EventViewModel>(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const SectionTitle('Eventos'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Mis eventos'), Tab(text: 'Como colaborador')],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          onPressed:
              () => Navigator.pushNamed(context, '/choose-event-creation'),
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            _buildEventsList(
              evm.events,
              evm.isLoading,
              cs,
              tt,
              _refreshEvents,
              'Aún no tienes eventos',
              isCollaborator: false,
            ),
            _buildEventsList(
              evm.collaboratorEvents,
              evm.isLoading,
              cs,
              tt,
              _refreshEvents,
              'No colaboras en ningún evento',
              isCollaborator: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(
    List<EventModel> events,
    bool isLoading,
    ColorScheme cs,
    TextTheme tt,
    Future<void> Function() onRefresh,
    String emptyText, {
    required bool isCollaborator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.horizontalMargin,
        vertical: Spacing.verticalMargin,
      ),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child:
            isLoading && events.isEmpty
                ? const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                )
                : events.isEmpty
                ? DashedBorder(
                  radius: 12,
                  color: cs.onTertiaryContainer,
                  strokeWidth: 2,
                  dashWidth: 8,
                  dashGap: 4,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(Spacing.spacingMedium),
                    child: Text(emptyText, style: tt.titleLarge),
                  ),
                )
                : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: events.length,
                  separatorBuilder:
                      (_, __) => const SizedBox(height: Spacing.spacingMedium),
                  itemBuilder: (ctx, i) {
                    return NextEventCard(
                      event: events[i],
                      imagePath: 'assets/images/1.png',
                      isCollaborator: isCollaborator,
                    );
                  },
                ),
      ),
    );
  }
}
