class Appointment {
  final int id;
  final int patientId;
  final int doctorId;
  final int serviceId;
  final DateTime appointmentTime;
  final String status;
  final String? doctorNotes;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.serviceId,
    required this.appointmentTime,
    required this.status,
    this.doctorNotes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      serviceId: json['service_id'],
      appointmentTime: DateTime.parse(json['appointment_time']),
      status: json['status'],
      doctorNotes: json['doctor_notes'],
    );
  }
}