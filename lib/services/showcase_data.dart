import '../models/activity_model.dart';
import '../models/collaborator_model.dart';
import '../models/event_model.dart';
import '../models/expense_model.dart';
import '../models/guest_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class ShowcaseUser {
  final UserModel profile;
  final String password;

  const ShowcaseUser({required this.profile, required this.password});
}

class ShowcaseData {
  static final List<ShowcaseUser> _users = [
    ShowcaseUser(
      profile: UserModel(
        id: 'user_1',
        name: 'Sofía Martínez',
        email: 'sofia.martinez@meetup.dev',
      ),
      password: 'meetup123',
    ),
    ShowcaseUser(
      profile: UserModel(
        id: 'user_2',
        name: 'Luis Herrera',
        email: 'luis.herrera@meetup.dev',
      ),
      password: 'meetup123',
    ),
  ];

  static UserModel currentUser = _users.first.profile;

  static List<UserModel> get users =>
      _users.map((user) => user.profile).toList();

  static final List<CollaboratorModel> collaborators = [
    CollaboratorModel(
      id: 'user_1',
      name: 'Sofía Martínez',
      email: 'sofia.martinez@meetup.dev',
    ),
    CollaboratorModel(
      id: 'user_2',
      name: 'Luis Herrera',
      email: 'luis.herrera@meetup.dev',
    ),
    CollaboratorModel(
      id: 'user_3',
      name: 'Camila Ríos',
      email: 'camila.rios@meetup.dev',
    ),
    CollaboratorModel(
      id: 'user_4',
      name: 'Diego Salas',
      email: 'diego.salas@meetup.dev',
    ),
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
    EventModel(
      id: 'event_3',
      name: 'Festival Gastronómico Local',
      description: 'Una tarde de sabores locales con food trucks y música.',
      location: 'Plaza Mayor, Barranco',
      category: 'get-together',
      startTime: DateTime(2025, 7, 20, 15, 0),
      endTime: DateTime(2025, 7, 20, 22, 0),
      imageUrl: '4.png',
      createdBy: 'user_1',
      budget: 2200,
      collaborators: ['user_2', 'user_4'],
    ),
    EventModel(
      id: 'event_4',
      name: 'Boda Boutique en la Costa',
      description: 'Ceremonia íntima frente al mar con estilo minimalista.',
      location: 'Costa Verde, Lima',
      category: 'birthday',
      startTime: DateTime(2025, 9, 5, 16, 0),
      endTime: DateTime(2025, 9, 5, 23, 30),
      imageUrl: '6.png',
      createdBy: 'user_3',
      budget: 4500,
      collaborators: ['user_1', 'user_2'],
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
    ExpenseModel(
      id: 'expense_3',
      name: 'Alquiler de carpas',
      amount: 600,
      category: 'Logística',
      description: 'Carpas para food trucks y zona de descanso.',
      date: DateTime(2025, 7, 5),
      eventId: 'event_3',
    ),
    ExpenseModel(
      id: 'expense_4',
      name: 'Sonido y DJ',
      amount: 420,
      category: 'Entretenimiento',
      description: 'Sistema de sonido y ambientación musical.',
      date: DateTime(2025, 7, 10),
      eventId: 'event_3',
    ),
    ExpenseModel(
      id: 'expense_5',
      name: 'Publicidad en redes',
      amount: 260,
      category: 'Marketing',
      description: 'Campañas digitales para atraer visitantes.',
      date: DateTime(2025, 7, 12),
      eventId: 'event_3',
    ),
    ExpenseModel(
      id: 'expense_6',
      name: 'Decoración floral',
      amount: 850,
      category: 'Decoración',
      description: 'Arcos florales y centros de mesa.',
      date: DateTime(2025, 8, 18),
      eventId: 'event_4',
    ),
    ExpenseModel(
      id: 'expense_7',
      name: 'Catering premium',
      amount: 1800,
      category: 'Comida',
      description: 'Menú de tres tiempos y barra libre.',
      date: DateTime(2025, 8, 28),
      eventId: 'event_4',
    ),
    ExpenseModel(
      id: 'expense_8',
      name: 'Iluminación',
      amount: 520,
      category: 'Logística',
      description: 'Iluminación cálida para ceremonia y cena.',
      date: DateTime(2025, 8, 30),
      eventId: 'event_4',
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
    GuestModel(
      id: 'guest_4',
      name: 'Renzo Vega',
      email: 'renzo.vega@correo.com',
      status: 'confirmed',
      eventId: 'event_3',
      invitationSent: true,
      createdAt: DateTime(2025, 6, 25),
      updatedAt: DateTime(2025, 7, 1),
    ),
    GuestModel(
      id: 'guest_5',
      name: 'Paola Ruiz',
      email: 'paola.ruiz@correo.com',
      status: 'pending',
      eventId: 'event_3',
      invitationSent: true,
      createdAt: DateTime(2025, 6, 26),
      updatedAt: DateTime(2025, 6, 26),
    ),
    GuestModel(
      id: 'guest_6',
      name: 'Santiago Pardo',
      email: 'santiago.pardo@correo.com',
      status: 'confirmed',
      eventId: 'event_3',
      invitationSent: true,
      createdAt: DateTime(2025, 6, 27),
      updatedAt: DateTime(2025, 7, 2),
    ),
    GuestModel(
      id: 'guest_7',
      name: 'Isabella Cárdenas',
      email: 'isabella.cardenas@correo.com',
      status: 'confirmed',
      eventId: 'event_4',
      invitationSent: true,
      isVip: true,
      createdAt: DateTime(2025, 8, 2),
      updatedAt: DateTime(2025, 8, 12),
    ),
    GuestModel(
      id: 'guest_8',
      name: 'Mateo Aguilar',
      email: 'mateo.aguilar@correo.com',
      status: 'pending',
      eventId: 'event_4',
      invitationSent: false,
      createdAt: DateTime(2025, 8, 4),
      updatedAt: DateTime(2025, 8, 4),
    ),
    GuestModel(
      id: 'guest_9',
      name: 'Lucía Torres',
      email: 'lucia.torres@correo.com',
      status: 'confirmed',
      eventId: 'event_4',
      invitationSent: true,
      createdAt: DateTime(2025, 8, 6),
      updatedAt: DateTime(2025, 8, 16),
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
    ActivityModel(
      id: 'activity_3',
      name: 'Montaje de stands',
      description: 'Organizar puestos y señalética del evento.',
      location: 'Plaza Mayor',
      startTime: DateTime(2025, 7, 20, 12, 0),
      endTime: DateTime(2025, 7, 20, 14, 0),
      eventId: 'event_3',
    ),
    ActivityModel(
      id: 'activity_4',
      name: 'Show de cocina en vivo',
      description: 'Demostraciones de chefs invitados.',
      location: 'Escenario central',
      startTime: DateTime(2025, 7, 20, 17, 0),
      endTime: DateTime(2025, 7, 20, 18, 30),
      eventId: 'event_3',
    ),
    ActivityModel(
      id: 'activity_5',
      name: 'Cierre con música',
      description: 'DJ set y agradecimientos finales.',
      location: 'Escenario central',
      startTime: DateTime(2025, 7, 20, 21, 0),
      endTime: DateTime(2025, 7, 20, 22, 0),
      eventId: 'event_3',
    ),
    ActivityModel(
      id: 'activity_6',
      name: 'Ceremonia',
      description: 'Intercambio de votos frente al mar.',
      location: 'Terraza principal',
      startTime: DateTime(2025, 9, 5, 16, 30),
      endTime: DateTime(2025, 9, 5, 17, 30),
      eventId: 'event_4',
    ),
    ActivityModel(
      id: 'activity_7',
      name: 'Sesión de fotos',
      description: 'Fotos con familiares y amigos.',
      location: 'Jardín privado',
      startTime: DateTime(2025, 9, 5, 17, 45),
      endTime: DateTime(2025, 9, 5, 18, 30),
      eventId: 'event_4',
    ),
    ActivityModel(
      id: 'activity_8',
      name: 'Cena y brindis',
      description: 'Cena gourmet y brindis final.',
      location: 'Salón principal',
      startTime: DateTime(2025, 9, 5, 19, 0),
      endTime: DateTime(2025, 9, 5, 22, 0),
      eventId: 'event_4',
    ),
  ];

  static int _eventCounter = 5;
  static int _taskCounter = 4;
  static int _expenseCounter = 9;
  static int _guestCounter = 10;
  static int _activityCounter = 9;

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

  static ShowcaseUser? findUserByEmail(String email) {
    try {
      return _users.firstWhere(
        (user) => user.profile.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  static ShowcaseUser registerUser({
    required String name,
    required String email,
    required String password,
  }) {
    if (findUserByEmail(email) != null) {
      throw Exception('El email ya está registrado');
    }

    final newUser = ShowcaseUser(
      profile: UserModel(
        id: 'user_${_users.length + 1}',
        name: name,
        email: email,
      ),
      password: password,
    );
    _users.add(newUser);
    collaborators.add(
      CollaboratorModel(
        id: newUser.profile.id,
        name: newUser.profile.name,
        email: newUser.profile.email,
      ),
    );
    return newUser;
  }
}
