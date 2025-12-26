import '../models/activity_model.dart';
import '../models/collaborator_model.dart';
import '../models/event_model.dart';
import '../models/expense_model.dart';
import '../models/guest_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class ShowcaseData {
  static final UserModel currentUser = UserModel(
    id: 'user_1',
    name: 'Sofía Martínez',
    email: 'sofia.martinez@meetup.dev',
  );

  static final List<CollaboratorModel> collaborators = [
    CollaboratorModel(id: 'user_1', name: 'Sofía Martínez', email: 'sofia.martinez@meetup.dev'),
    CollaboratorModel(id: 'user_2', name: 'Luis Herrera', email: 'luis.herrera@meetup.dev'),
    CollaboratorModel(id: 'user_3', name: 'Camila Ríos', email: 'camila.rios@meetup.dev'),
    CollaboratorModel(id: 'user_4', name: 'Diego Salas', email: 'diego.salas@meetup.dev'),
  ];

  static final List<EventModel> events = [
    EventModel(
      id: 'event_1',
      name: 'Cumpleaños en el Jardín',
      description: 'Celebración íntima con decoración floral y música en vivo.',
      location: 'Parque Central, Miraflores',
      category: 'birthday',
      startTime: DateTime(2025, 5, 12, 18, 0),
      endTime: DateTime(2025, 5, 12, 23, 0),
      imageUrl: 'birthday.png',
      createdBy: 'user_1',
      budget: 1500,
      collaborators: ['user_2', 'user_3'],
    ),
    EventModel(
      id: 'event_2',
      name: 'Reunión Creativa de Equipo',
      description: 'Planificación del trimestre con dinámica de ideas.',
      location: 'Coworking Distrito 22',
      category: 'get-together',
      startTime: DateTime(2025, 6, 2, 9, 30),
      endTime: DateTime(2025, 6, 2, 14, 30),
      imageUrl: 'friends.png',
      createdBy: 'user_2',
      budget: 800,
      collaborators: ['user_1', 'user_4'],
    ),
  ];

  static final List<TaskModel> tasks = [
    TaskModel(
      id: 'task_1',
      title: 'Confirmar catering',
      description: 'Definir menú vegetariano y bebidas.',
      status: 'pending',
      eventId: 'event_1',
      eventName: 'Cumpleaños en el Jardín',
      assignedUserId: 'user_2',
      assignedUserName: 'Luis Herrera',
      assignedUserEmail: 'luis.herrera@meetup.dev',
    ),
    TaskModel(
      id: 'task_2',
      title: 'Crear lista de reproducción',
      description: 'Seleccionar música para ambientar la noche.',
      status: 'completed',
      eventId: 'event_1',
      eventName: 'Cumpleaños en el Jardín',
      assignedUserId: 'user_3',
      assignedUserName: 'Camila Ríos',
      assignedUserEmail: 'camila.rios@meetup.dev',
    ),
    TaskModel(
      id: 'task_3',
      title: 'Preparar agenda del taller',
      description: 'Definir tiempos y dinámica del brainstorming.',
      status: 'pending',
      eventId: 'event_2',
      eventName: 'Reunión Creativa de Equipo',
      assignedUserId: 'user_1',
      assignedUserName: 'Sofía Martínez',
      assignedUserEmail: 'sofia.martinez@meetup.dev',
    ),
  ];

  static final List<ExpenseModel> expenses = [
    ExpenseModel(
      id: 'expense_1',
      name: 'Decoración floral',
      amount: 320,
      category: 'Decoración',
      description: 'Arreglo de mesa y centros de flores.',
      date: DateTime(2025, 5, 2),
      eventId: 'event_1',
    ),
    ExpenseModel(
      id: 'expense_2',
      name: 'Coffee break',
      amount: 180,
      category: 'Comida',
      description: 'Snacks, café y jugos naturales.',
      date: DateTime(2025, 5, 28),
      eventId: 'event_2',
    ),
  ];

  static final List<GuestModel> guests = [
    GuestModel(
      id: 'guest_1',
      name: 'Valentina López',
      email: 'valentina.lopez@correo.com',
      status: 'confirmed',
      eventId: 'event_1',
      invitationSent: true,
      isVip: true,
      createdAt: DateTime(2025, 4, 20),
      updatedAt: DateTime(2025, 4, 30),
    ),
    GuestModel(
      id: 'guest_2',
      name: 'Miguel Ortega',
      email: 'miguel.ortega@correo.com',
      status: 'pending',
      eventId: 'event_1',
      invitationSent: true,
      createdAt: DateTime(2025, 4, 22),
      updatedAt: DateTime(2025, 4, 22),
    ),
    GuestModel(
      id: 'guest_3',
      name: 'Andrea Muñoz',
      email: 'andrea.munoz@correo.com',
      status: 'confirmed',
      eventId: 'event_2',
      invitationSent: true,
      createdAt: DateTime(2025, 5, 10),
      updatedAt: DateTime(2025, 5, 15),
    ),
  ];

  static final List<ActivityModel> activities = [
    ActivityModel(
      id: 'activity_1',
      name: 'Recepción de invitados',
      description: 'Bienvenida y fotos de ingreso.',
      location: 'Entrada principal',
      startTime: DateTime(2025, 5, 12, 18, 0),
      endTime: DateTime(2025, 5, 12, 19, 0),
      eventId: 'event_1',
    ),
    ActivityModel(
      id: 'activity_2',
      name: 'Sesión de ideas',
      description: 'Dinámica colaborativa con post-its.',
      location: 'Sala Aurora',
      startTime: DateTime(2025, 6, 2, 10, 0),
      endTime: DateTime(2025, 6, 2, 12, 0),
      eventId: 'event_2',
    ),
  ];

  static int _eventCounter = 3;
  static int _taskCounter = 4;
  static int _expenseCounter = 3;
  static int _guestCounter = 4;
  static int _activityCounter = 3;

  static String nextEventId() => 'event_${_eventCounter++}';
  static String nextTaskId() => 'task_${_taskCounter++}';
  static String nextExpenseId() => 'expense_${_expenseCounter++}';
  static String nextGuestId() => 'guest_${_guestCounter++}';
  static String nextActivityId() => 'activity_${_activityCounter++}';

  static EventModel? findEvent(String eventId) {
    try {
      return events.firstWhere((event) => event.id == eventId);
    } catch (_) {
      return null;
    }
  }

  static int findEventIndex(String eventId) =>
      events.indexWhere((event) => event.id == eventId);
}
