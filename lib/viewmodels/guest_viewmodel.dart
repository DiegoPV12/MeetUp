import 'package:flutter/material.dart';
import '../models/guest_model.dart';
import '../services/guest_service.dart';

class GuestViewModel extends ChangeNotifier {
  final GuestService _guestService = GuestService();
  List<GuestModel> _guests = [];
  bool isLoading = false;

  List<GuestModel> get guests => _guests;

  Future<void> loadGuests(String eventId) async {
    isLoading = true;
    notifyListeners();
    _guests = await _guestService.getGuestsByEvent(eventId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> addGuest(GuestModel guest) async {
    await _guestService.createGuest(guest);
    await loadGuests(guest.eventId);
  }

  Future<void> updateGuest(GuestModel guest) async {
    await _guestService.updateGuest(guest);
    await loadGuests(guest.eventId);
  }

  Future<void> deleteGuest(String id, String eventId) async {
    await _guestService.deleteGuest(id);
    await loadGuests(eventId);
  }
}
