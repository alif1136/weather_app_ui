// lib/data/repository/weather_repository.dart
import '../models/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getWeather({
    required double lat,
    required double lon,
  });
}
