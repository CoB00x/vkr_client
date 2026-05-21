import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/available_slot.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final int? doctorId;
  final String? doctorName;
  final int? serviceId;
  final String? serviceName;

  const BookingScreen({
    super.key,
    this.doctorId,
    this.doctorName,
    this.serviceId,
    this.serviceName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  List<AvailableSlot> _slots = [];
  bool _isLoading = true;
  int? _selectedDoctorId;
  int? _selectedServiceId;
  List<Map<String, dynamic>> _doctorServices = [];
  bool _isLoadingServices = false;

  // Для фильтрации по дате
  DateTime _selectedDate = DateTime.now();
  List<AvailableSlot> _filteredSlots = [];

  @override
  void initState() {
    super.initState();
    _selectedDoctorId = widget.doctorId;
    _selectedServiceId = widget.serviceId;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Если выбран врач, загружаем его услуги
    if (_selectedDoctorId != null && _selectedServiceId == null) {
      await _loadDoctorServices();
    }

    await _loadSlots();

    setState(() => _isLoading = false);
  }

  Future<void> _loadDoctorServices() async {
    setState(() => _isLoadingServices = true);
    try {
      final services = await _apiService.getDoctorServices(_selectedDoctorId!);
      setState(() {
        _doctorServices = services;
        _isLoadingServices = false;
      });
    } catch (e) {
      setState(() => _isLoadingServices = false);
    }
  }

  Future<void> _loadSlots() async {
    final slots = await _apiService.getAvailableSlots(
      serviceId: _selectedServiceId,
      doctorId: _selectedDoctorId,
    );
    setState(() {
      _slots = slots;
      _filterSlotsByDate();
    });
  }

  void _filterSlotsByDate() {
    setState(() {
      _filteredSlots = _slots.where((slot) {
        return slot.startTime.year == _selectedDate.year &&
            slot.startTime.month == _selectedDate.month &&
            slot.startTime.day == _selectedDate.day;
      }).toList();
    });
  }

  Future<void> _bookSlot(AvailableSlot slot) async {
    // Проверяем авторизацию
    final isAuth = await _authService.isAuthenticated();

    if (!isAuth) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (result != true) return;
    }

    // Подтверждение записи
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Подтверждение записи'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Врач: ${slot.doctorName}'),
            const SizedBox(height: 8),
            Text('Услуга: ${slot.serviceName}'),
            const SizedBox(height: 8),
            Text('Дата: ${DateFormat('dd.MM.yyyy').format(slot.startTime)}'),
            Text('Время: ${DateFormat('HH:mm').format(slot.startTime)}'),
            const SizedBox(height: 8),
            Text('Цена: ${slot.servicePrice.toStringAsFixed(0)} ₽'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      final success = await _apiService.bookAppointment(
        doctorId: slot.doctorId,
        serviceId: slot.serviceId,
        appointmentTime: slot.startTime,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Запись успешно создана!')),
        );
        Navigator.pop(context, true); // Возвращаем true для обновления списка записей
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при создании записи')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctorName != null
            ? 'Запись к ${widget.doctorName}'
            : 'Запись на услугу'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Выбор услуги (если выбран врач, но не выбрана услуга)
          if (_selectedDoctorId != null && _selectedServiceId == null) ...[
            _buildServiceSelector(),
            const Divider(),
          ],

          // Выбор даты
          _buildDateSelector(),

          const Divider(),

          // Список слотов
          Expanded(
            child: _filteredSlots.isEmpty
                ? const Center(child: Text('Нет доступных слотов на выбранную дату'))
                : ListView.builder(
              itemCount: _groupSlotsByDoctor().keys.length,
              itemBuilder: (context, index) {
                final doctorId = _groupSlotsByDoctor().keys.elementAt(index);
                final slots = _groupSlotsByDoctor()[doctorId]!;
                final doctorName = slots.first.doctorName;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    ...slots.map((slot) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.access_time, color: Colors.blue),
                        title: Text(
                          '${slot.startTime.hour.toString().padLeft(2, '0')}:${slot.startTime.minute.toString().padLeft(2, '0')}',
                        ),
                        subtitle: Text('${slot.serviceName} - ${slot.servicePrice.toStringAsFixed(0)} ₽'),
                        trailing: ElevatedButton(
                          onPressed: () => _bookSlot(slot),
                          child: const Text('Записаться'),
                        ),
                      ),
                    )),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelector() {
    if (_isLoadingServices) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Выберите услугу:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _doctorServices.length,
              itemBuilder: (context, index) {
                final service = _doctorServices[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(service['name']),
                    selected: _selectedServiceId == service['id'],
                    onSelected: (selected) {
                      setState(() {
                        _selectedServiceId = selected ? service['id'] : null;
                      });
                      _loadSlots();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    final dates = <DateTime>[];

    for (int i = 0; i <= 3; i++) {
      dates.add(now.add(Duration(days: i)));
    }

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('E', 'ru').format(date),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    DateFormat('dd.MM').format(date),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedDate = date;
                  _filterSlotsByDate();
                });
              },
            ),
          );
        },
      ),
    );
  }

  // Добавьте метод для группировки слотов по врачам
  Map<int, List<AvailableSlot>> _groupSlotsByDoctor() {
    final Map<int, List<AvailableSlot>> grouped = {};
    for (final slot in _filteredSlots) {
      if (!grouped.containsKey(slot.doctorId)) {
        grouped[slot.doctorId] = [];
      }
      grouped[slot.doctorId]!.add(slot);
    }
    return grouped;
  }
}