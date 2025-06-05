class EventTemplate {
  final String name;
  final String description;
  final String imageUrl;

  EventTemplate({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class EventTemplates {
  static final Map<String, EventTemplate> templates = {
    'birthday': EventTemplate(
      name: 'Fiesta de Cumpleaños',
      description:
          'Ven a celebrar un cumpleaños inolvidable lleno de alegría, pastel y buena compañía.',
      imageUrl: '1.png',
    ),
    'get-together': EventTemplate(
      name: 'Junte con Amigos',
      description:
          'Un espacio para compartir, reír y ponerse al día con los que más quieres.',
      imageUrl: '2.png',
    ),
  };

  static EventTemplate? getForCategory(String? category) {
    if (category == null) return null;
    return templates[category];
  }
}
