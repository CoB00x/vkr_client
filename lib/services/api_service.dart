import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../models/service.dart';
import 'auth_service.dart';
import '../utils/constants.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Doctor>> getDoctors() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.doctorsEndpoint}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Doctor.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Service>> getServices() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.servicesEndpoint}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Appointment>> getMyAppointments() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appointmentsEndpoint}'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appointment.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> createAppointment(int doctorId, int serviceId, DateTime time) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appointmentsEndpoint}'),
      headers: headers,
      body: json.encode({
        'doctor_id': doctorId,
        'service_id': serviceId,
        'appointment_time': time.toIso8601String(),
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> cancelAppointment(int appointmentId) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appointmentsEndpoint}/$appointmentId'),
      headers: headers,
    );
    return response.statusCode == 200;
  }
}