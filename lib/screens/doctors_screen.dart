import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final ApiService _apiService = ApiService();
  List<Doctor> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final doctors = await _apiService.getDoctors();
    setState(() {
      _doctors = doctors;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Врачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _doctors.isEmpty
          ? const Center(child: Text('Врачи не найдены'))
          : ListView.builder(
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(doctor: _doctors[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Врачи'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Записи'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Услуги'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/appointments');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/services');
          }
        },
      ),
    );
  }
}