class ExpenseModel {
  final String id;
  final String name;
  final double amount;
  final String category;
  final String? description;
  final DateTime date;
  final String eventId;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    this.description,
    required this.date,
    required this.eventId,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['_id'],
    name: json['name'],
    amount: (json['amount'] as num).toDouble(),
    category: json['category'],
    description: json['description'],
    date: DateTime.parse(json['date']),
    eventId: json['event'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'category': category,
    'description': description,
    'date': date.toIso8601String(),
  };

  ExpenseModel copyWith({
    String? name,
    double? amount,
    String? category,
    String? description,
  }) {
    return ExpenseModel(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date,
      eventId: eventId,
    );
  }
}
