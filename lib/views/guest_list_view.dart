import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/guest_model.dart';
import '../../viewmodels/guest_viewmodel.dart';
import '../widgets/guests/guest_tile.dart';
import '../widgets/guests/guest_form_bottom_sheet.dart';

class GuestListView extends StatelessWidget {
  final String eventId;
  const GuestListView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuestViewModel()..loadGuests(eventId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Invitados'), centerTitle: true),
        floatingActionButton: Consumer<GuestViewModel>(
          builder:
              (context, vm, _) => FloatingActionButton(
                onPressed:
                    () =>
                        showGuestFormBottomSheet(context, vm, eventId: eventId),
                child: const Icon(Icons.add),
              ),
        ),
        body: Consumer<GuestViewModel>(
          builder: (context, vm, _) {
            return vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.guests.isEmpty
                ? const Center(
                  child: Text('Aún no hay invitados para este evento'),
                )
                : ListView.builder(
                  itemCount: vm.guests.length,
                  itemBuilder: (context, i) {
                    final guest = vm.guests[i];
                    return GuestTile(
                      guest: guest,
                      onDelete: () => vm.deleteGuest(guest.id, eventId),
                      onEdit:
                          () => showGuestFormBottomSheet(
                            context,
                            vm,
                            eventId: eventId,
                            existingGuest: guest,
                          ),
                    );
                  },
                );
          },
        ),
      ),
    );
  }
}
