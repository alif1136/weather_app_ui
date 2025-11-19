// lib/data/repository/weather_repository.dart
import '../models/weather_model.dart';

// lib/data/repository/weather_repository.dart
abstract class WeatherRepository {
  Future<Map<String, dynamic>> fetchGeo(String city);
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon);
}


