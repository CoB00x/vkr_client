import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/appointment.dart';
import '../widgets/appointment_card.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  bool _showFuture = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoad();
  }

  Future<void> _checkAuthAndLoad() async {
    final isAuth = await _authService.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuth;
    });
    if (isAuth) {
      await _loadAppointments();
    } else {
      setState(() => _isLoading = false);
    }
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
        content: Text('Вы уверены, что хотите отменить запись на ${DateFormat('dd.MM.yyyy HH:mm').format(appointment.appointmentTime)}?'),
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

  List<Appointment> get _filteredAppointments {
    final now = DateTime.now();
    return _appointments.where((a) {
      return _showFuture ? a.appointmentTime.isAfter(now) : a.appointmentTime.isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Мои записи')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Чтобы просматривать записи,\nнеобходимо войти в аккаунт',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  if (result == true) {
                    _checkAuthAndLoad();
                  }
                },
                child: const Text('Войти в аккаунт'),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = _filteredAppointments;

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
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _showFuture ? 'Нет будущих записей' : 'Нет прошедших записей',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Перейдите во вкладку "Врачи", чтобы записаться на приём',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      )
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