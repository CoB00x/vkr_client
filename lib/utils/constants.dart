class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000'; // для Android эмулятора
  // static const String baseUrl = 'http://localhost:8000'; // для iOS
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String doctorsEndpoint = '/api/doctors';
  static const String appointmentsEndpoint = '/api/appointments';
  static const String servicesEndpoint = '/api/services';
  static const String bookingSlotsEndpoint = '/api/booking/available-slots';
  static const String bookEndpoint = '/api/booking/book';
  static const String doctorServicesEndpoint = '/api/booking/doctor-services';
}

class AppConstants {
  static const String accessTokenKey = 'access_token';
}