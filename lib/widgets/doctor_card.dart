import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../screens/booking_screen.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(
                  doctorId: doctor.id,
                  doctorName: doctor.fullName,
                ),
              ),
            );
          },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Аватар врача
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medical_information, size: 32, color: Colors.blue),
              ),
              const SizedBox(width: 16),

              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialization,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    if (doctor.experienceYears != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.work, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Стаж: ${doctor.experienceYears} ${_getYearsDeclension(doctor.experienceYears!)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Стрелка
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _getYearsDeclension(int years) {
    if (years % 10 == 1 && years % 100 != 11) return 'год';
    if (years % 10 >= 2 && years % 10 <= 4 && (years % 100 < 10 || years % 100 >= 20)) return 'года';
    return 'лет';
  }
}