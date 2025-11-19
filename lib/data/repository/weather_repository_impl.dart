// lib/data/repository/weather_repository_impl.dart
import 'package:weather_app_ui/data/repository/weather_repository.dart';
import '../services/weather_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherService service;

  WeatherRepositoryImpl(this.service);

  @override
  Future<Map<String, dynamic>> fetchGeo(String city) {
    return service.getGeoLocation(city);
  }

  @override
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) {
    return service.getWeather(lat, lon);
  }
}
