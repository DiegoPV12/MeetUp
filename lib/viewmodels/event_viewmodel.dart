import 'package:flutter/material.dart';
import 'package:meetup/services/task_service.dart';
import '../models/event_request_model.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<EventModel> _events = [];
  List<EventModel> get events => _events;

  List<EventModel> _collaboratorEvents = [];
  List<EventModel> get collaboratorEvents => _collaboratorEvents;

  Future<void> createEvent({
    required String name,
    required String description,
    required String location,
    required String category,
    required DateTime startTime,
    DateTime? endTime,
    required String imageUrl,
    String? template,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final eventRequest = EventRequest(
        name: name,
        description: description,
        location: location,
        category: category,
        startTime: startTime,
        endTime: endTime,
        imageUrl: imageUrl,
      );

      final createdEventId = await _eventService.createEvent(eventRequest);

      if (template != null) {
        final taskService = TaskService();
        final defaultTasks = _getDefaultTasksForCategory(template);

        for (final task in defaultTasks) {
          await taskService.createTask(
            createdEventId,
            task['title']!,
            task['description']!,
          );
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _eventService.fetchEvents();
    } catch (e) {
      _events = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEventsAsCollaborator() async {
    _isLoading = true;
    notifyListeners();

    try {
      _collaboratorEvents = await _eventService.fetchEventsAsCollaborator();
    } catch (e) {
      _collaboratorEvents = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, String>> _getDefaultTasksForCategory(String category) {
    switch (category) {
      case 'birthday':
        return [
          {
            'title': 'Reservar salón de fiestas',
            'description': 'Confirmar lugar para la fiesta.',
          },
          {
            'title': 'Enviar invitaciones',
            'description': 'Enviar invitaciones a todos los invitados.',
          },
          {
            'title': 'Contratar animador',
            'description': 'Buscar y contratar un animador infantil.',
          },
          {
            'title': 'Comprar torta',
            'description': 'Encargar torta de cumpleaños.',
          },
          {
            'title': 'Organizar juegos',
            'description': 'Planificar juegos y actividades para niños.',
          },
        ];
      case 'get-together':
        return [
          {
            'title': 'Definir lugar del encuentro',
            'description': 'Escoger casa o local para el evento.',
          },
          {
            'title': 'Armar playlist',
            'description': 'Crear lista de música para ambientar.',
          },
          {
            'title': 'Comprar snacks y bebidas',
            'description': 'Hacer lista y comprar todo para picar.',
          },
          {
            'title': 'Decorar espacio',
            'description': 'Preparar decoración sencilla y acogedora.',
          },
          {
            'title': 'Enviar recordatorio',
            'description': 'Recordar a todos los invitados por WhatsApp.',
          },
        ];
      default:
        return [];
    }
  }
}
