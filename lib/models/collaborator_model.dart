class CollaboratorModel {
  final String id;
  final String name;
  final String email;

  CollaboratorModel({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Para respuestas que usan "_id"
  factory CollaboratorModel.fromJson(Map<String, dynamic> json) {
    return CollaboratorModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  @override
  String toString() => 'Collaborator(id: $id, name: $name, email: $email)';

  factory CollaboratorModel.empty() {
    return CollaboratorModel(id: '', name: '', email: '');
  }
}
