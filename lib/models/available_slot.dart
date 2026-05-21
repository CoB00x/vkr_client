class AvailableSlot {
  final int doctorId;
  final String doctorName;
  final DateTime startTime;
  final DateTime endTime;
  final int serviceId;
  final String serviceName;
  final double servicePrice;
  final int serviceDuration;

  AvailableSlot({
    required this.doctorId,
    required this.doctorName,
    required this.startTime,
    required this.endTime,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDuration,
  });

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      doctorId: json['doctor_id'],
      doctorName: json['doctor_name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      servicePrice: json['service_price'].toDouble(),
      serviceDuration: json['service_duration'],
    );
  }

  String get formattedTime {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDate {
    final day = startTime.day.toString().padLeft(2, '0');
    final month = startTime.month.toString().padLeft(2, '0');
    return '$day.$month';
  }
}