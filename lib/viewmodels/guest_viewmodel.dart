import 'package:flutter/material.dart';
import '../models/guest_model.dart';
import '../services/guest_service.dart';

class GuestViewModel extends ChangeNotifier {
  final GuestService _guestService = GuestService();
  List<GuestModel> _allGuests = [];
  bool isLoading = false;
  String _searchTerm = '';
  String _statusFilter = 'all'; // 'all', 'pending', 'confirmed', 'declined'
  String get currentFilter => _statusFilter;

  List<GuestModel> get guests {
    var filtered = _allGuests;
    if (_statusFilter != 'all') {
      filtered = filtered.where((g) => g.status == _statusFilter).toList();
    }
    if (_searchTerm.isNotEmpty) {
      filtered =
          filtered
              .where(
                (g) =>
                    g.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
                    g.email.toLowerCase().contains(_searchTerm.toLowerCase()),
              )
              .toList();
    }
    return filtered;
  }

  Future<void> loadGuests(String eventId) async {
    isLoading = true;
    notifyListeners();
    _allGuests = await _guestService.getGuestsByEvent(eventId);
    isLoading = false;
    notifyListeners();
  }

  void updateSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void updateStatusFilter(String status) {
    _statusFilter = status;
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

  Future<void> sendInvitations(String eventId, String message) async {
    await _guestService.sendInvitations(eventId, message);
    await loadGuests(eventId);
  }

  Future<void> sendReminders(String eventId, String message) async {
    await _guestService.sendReminders(eventId, message);
    await loadGuests(eventId);
  }
}
