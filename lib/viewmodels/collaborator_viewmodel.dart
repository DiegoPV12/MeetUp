import 'package:flutter/material.dart';
import 'package:meetup/models/collaborator_model.dart';
import 'package:meetup/services/collaborator_service.dart';

class CollaboratorViewModel extends ChangeNotifier {
  final CollaboratorService _service = CollaboratorService();

  List<CollaboratorModel> _allUsers = [];
  List<CollaboratorModel> get allUsers => _allUsers;

  List<CollaboratorModel> _collaborators = [];
  List<CollaboratorModel> get collaborators => _collaborators;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String _eventId;
  late String _creatorId;

  /// Inicializa el ViewModel con el eventId y el creatorId,
  /// luego carga usuarios y colaboradores.
  Future<void> init(String eventId, String creatorId) async {
    _eventId = eventId;
    _creatorId = creatorId;
    await _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allUsers = await _service.getAllUsers();
      _collaborators = await _service.getEventCollaborators(_eventId);
    } catch (e) {
      _allUsers = [];
      _collaborators = [];
      // en caso de error, dejamos las listas vacías
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Devuelve la lista de usuarios que no están todavía como colaboradores
  /// y excluye al usuario creador.
  List<CollaboratorModel> get availableUsers {
    return _allUsers.where((u) {
      final already = _collaborators.any((c) => c.id == u.id);
      final isCreator = u.id == _creatorId;
      return !already && !isCreator;
    }).toList();
  }

  /// Agrega un colaborador al evento:
  /// - Llama al servicio para persistir en backend.
  /// - Si todo OK, agrega al array local y notifica.
  Future<void> addCollaborator(CollaboratorModel user) async {
    try {
      await _service.addCollaborator(_eventId, user.id);
      _collaborators.add(user);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina un colaborador del evento:
  /// - Llama al servicio para persistir en backend.
  /// - Si todo OK, lo quita del array local y notifica.
  Future<void> removeCollaborator(CollaboratorModel user) async {
    try {
      await _service.removeCollaborator(_eventId, user.id);
      _collaborators.removeWhere((c) => c.id == user.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
