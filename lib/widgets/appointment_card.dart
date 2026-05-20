import 'package:flutter/material.dart';
import '../models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'active':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (appointment.status) {
      case 'active':
        return 'Ожидает подтверждения';
      case 'confirmed':
        return 'Подтверждена';
      case 'completed':
        return 'Завершена';
      case 'cancelled':
        return 'Отменена';
      default:
        return appointment.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPast = appointment.appointmentTime.isBefore(DateTime.now());
    final isCancelled = appointment.status == 'cancelled';
    final canCancel = onCancel != null && !isPast && !isCancelled;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(),
                      style: TextStyle(color: _getStatusColor(), fontSize: 12),
                    ),
                  ],
                ),
                if (canCancel)
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                    onPressed: onCancel,
                    tooltip: 'Отменить запись',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.event, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMMM yyyy', 'ru').format(appointment.appointmentTime),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(DateFormat('HH:mm').format(appointment.appointmentTime)),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.medical_services, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Услуга #${appointment.serviceId}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            if (appointment.doctorNotes != null && appointment.doctorNotes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.doctorNotes!,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ],
            if (onReschedule != null && !isPast && !isCancelled) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onReschedule,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Перенести запись'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}