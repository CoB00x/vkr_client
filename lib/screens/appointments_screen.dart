import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/appointment.dart';
import '../widgets/appointment_card.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final ApiService _apiService = ApiService();
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  bool _showFuture = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final appointments = await _apiService.getMyAppointments();
    setState(() {
      _appointments = appointments;
      _isLoading = false;
    });
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Отменить запись'),
        content: Text('Вы уверены, что хотите отменить запись к врачу на ${DateFormat('dd.MM.yyyy HH:mm').format(appointment.appointmentTime)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Нет')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Да')),
        ],
      ),
    );
    if (confirm == true) {
      final success = await _apiService.cancelAppointment(appointment.id);
      if (success) {
        _loadAppointments();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запись отменена')));
        }
      }
    }
  }

  List<Appointment> _getFilteredAppointments() {
    final now = DateTime.now();
    return _appointments.where((a) {
      return _showFuture ? a.appointmentTime.isAfter(now) : a.appointmentTime.isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredAppointments();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои записи'),
        actions: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Будущие')),
              ButtonSegment(value: false, label: Text('Прошедшие')),
            ],
            selected: {_showFuture},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() => _showFuture = newSelection.first);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
          ? Center(child: Text(_showFuture ? 'Нет будущих записей' : 'Нет прошедших записей'))
          : ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return AppointmentCard(
            appointment: filtered[index],
            onCancel: filtered[index].status != 'cancelled' && filtered[index].appointmentTime.isAfter(DateTime.now())
                ? () => _cancelAppointment(filtered[index])
                : null,
          );
        },
      ),
    );
  }
}