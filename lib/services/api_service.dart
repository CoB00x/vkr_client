import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/available_slot.dart';
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

  // Добавьте в конец класса ApiService

  Future<List<AvailableSlot>> getAvailableSlots({
    int? serviceId,
    int? doctorId,
  }) async {
    final queryParams = <String, String>{};

    if (serviceId != null) {
      queryParams['service_id'] = serviceId.toString();
    }
    if (doctorId != null) {
      queryParams['doctor_id'] = doctorId.toString();
    }

    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.bookingSlotsEndpoint}'
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AvailableSlot.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> bookAppointment({
    required int doctorId,
    required int serviceId,
    required DateTime appointmentTime,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookEndpoint}'),
      headers: headers,
      body: json.encode({
        'doctor_id': doctorId,
        'service_id': serviceId,
        'appointment_time': appointmentTime.toIso8601String(),
      }),
    );
    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getDoctorServices(int doctorId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.doctorServicesEndpoint}/$doctorId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }
}