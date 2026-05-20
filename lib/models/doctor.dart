class Doctor {
  final int id;
  final String fullName;
  final String specialization;
  final int? experienceYears;

  Doctor({
    required this.id,
    required this.fullName,
    required this.specialization,
    this.experienceYears,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['full_name'],
      specialization: json['specialization'],
      experienceYears: json['experience_years'],
    );
  }
}