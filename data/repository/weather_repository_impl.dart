// lib/data/repository/weather_repository_impl.dart
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherService service;

  WeatherRepositoryImpl({required this.service});

  @override
  Future<WeatherModel> getWeather({
    required double lat,
    required double lon,
  }) async {
    return await service.fetchWeather(lat: lat, lon: lon);
  }
}
