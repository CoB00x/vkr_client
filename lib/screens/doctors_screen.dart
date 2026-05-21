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
  String _searchQuery = '';

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

  List<Doctor> get _filteredDoctors {
    if (_searchQuery.isEmpty) return _doctors;
    return _doctors.where((doctor) {
      return doctor.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialization.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Наши врачи'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по имени или специальности...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredDoctors.isEmpty
          ? const Center(child: Text('Врачи не найдены'))
          : ListView.builder(
        itemCount: _filteredDoctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(doctor: _filteredDoctors[index]);
        },
      ),
    );
  }
}