class Service {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int durationMinutes;

  Service({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.durationMinutes,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['duration_minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_minutes': durationMinutes,
    };
  }

  String get formattedPrice => '${price.toStringAsFixed(0)} ₽';

  String get formattedDuration {
    if (durationMinutes >= 60) {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) return '$hours ч';
      return '$hours ч $minutes мин';
    }
    return '$durationMinutes мин';
  }
}