// lib/views/guest_list_view.dart
import 'package:flutter/material.dart';
import 'package:meetup/widgets/guests/guest_actions_bar.dart';
import 'package:meetup/widgets/guests/guest_list_body.dart';
import 'package:meetup/widgets/guests/guest_overview.dart';
import 'package:meetup/widgets/home/section_title.dart';
import 'package:provider/provider.dart';
import '../viewmodels/guest_viewmodel.dart';
import '../widgets/guests/guest_form_bottom_sheet.dart';

class GuestListView extends StatelessWidget {
  final String eventId;
  const GuestListView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuestViewModel()..loadGuests(eventId),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const SectionTitle('Invitados'),
            bottom: const TabBar(
              tabs: [Tab(text: 'Lista'), Tab(text: 'Resumen')],
            ),
            actions: [GuestActionsBar(eventId: eventId)],
          ),
          body: TabBarView(
            children: [
              GuestListBody(eventId: eventId),
              GuestOverviewView(eventId: eventId),
            ],
          ),
          floatingActionButton: Consumer<GuestViewModel>(
            builder:
                (_, vm, __) => FloatingActionButton(
                  onPressed:
                      () => showGuestFormBottomSheet(
                        context,
                        vm,
                        eventId: eventId,
                      ),
                  child: const Icon(Icons.add),
                ),
          ),
        ),
      ),
    );
  }
}
