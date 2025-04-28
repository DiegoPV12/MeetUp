// lib/views/list_events_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/views/widgets/dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:meetup/views/widgets/home/section_title.dart';
import 'package:meetup/views/widgets/home/next_event_card.dart';
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
      Provider.of<EventViewModel>(context, listen: false).fetchEvents();
    });
  }

  Future<void> _refreshEvents() async {
    await Provider.of<EventViewModel>(context, listen: false).fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final evm = Provider.of<EventViewModel>(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const SectionTitle('Eventos'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        onPressed: () => Navigator.pushNamed(context, '/choose-event-creation'),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.horizontalMargin,
          vertical: Spacing.verticalMargin,
        ),
        child: RefreshIndicator(
          onRefresh: _refreshEvents,
          child:
              evm.isLoading && evm.events.isEmpty
                  ? const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : evm.events.isEmpty
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
                      child: Text(
                        'Aún no tienes eventos',
                        style: tt.titleLarge,
                      ),
                    ),
                  )
                  : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: evm.events.length,
                    separatorBuilder:
                        (_, __) =>
                            const SizedBox(height: Spacing.spacingMedium),
                    itemBuilder: (ctx, i) {
                      return NextEventCard(
                        event: evm.events[i],
                        imagePath: 'assets/images/1.png',
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
