import 'package:flutter/material.dart';
import '../models/guest_model.dart';
import 'showcase_data.dart';

class GuestService {
  Future<List<GuestModel>> getGuestsByEvent(String eventId) async {
    return ShowcaseData.guests
        .where((guest) => guest.eventId == eventId)
        .toList();
  }

  Future<void> createGuest(GuestModel guest) async {
    ShowcaseData.guests.add(
      GuestModel(
        id: ShowcaseData.nextGuestId(),
        name: guest.name,
        email: guest.email,
        status: guest.status,
        eventId: guest.eventId,
        createdAt: guest.createdAt,
        updatedAt: guest.updatedAt,
        invitationSent: guest.invitationSent,
        isVip: guest.isVip,
      ),
    );
  }

  Future<void> updateGuest(GuestModel guest) async {
    final index =
        ShowcaseData.guests.indexWhere((existing) => existing.id == guest.id);
    if (index == -1) return;
    ShowcaseData.guests[index] = guest;
  }

  Future<void> deleteGuest(String id) async {
    ShowcaseData.guests.removeWhere((guest) => guest.id == id);
  }

  Future<void> sendInvitations(String eventId, String message) async {
    debugPrint('Invitaciones enviadas en modo showcase: $message');
  }

  Future<void> sendReminders(String eventId, String message) async {
    debugPrint('Recordatorios enviados en modo showcase: $message');
  }

  Future<void> sendSingleInvitation(String guestId) async {
    debugPrint('Invitación individual enviada en modo showcase: $guestId');
  }
}
