// lib/data/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    // Reverse geocoding
    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/reverse?latitude=$lat&longitude=$lon&language=en',
    );

    final geoRes = await http.get(geoUrl);
    String city = 'Unknown';
    String country = '';

    if (geoRes.statusCode == 200) {
      final geoJson = jsonDecode(geoRes.body);
      if (geoJson['results'] != null) {
        final r = geoJson['results'][0];
        city = r['name'] ?? 'Unknown';
        country = r['country'] ?? '';
      }
    }

    // Weather data
    final qs =
        '?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,weather_code,wind_speed_10m'
        '&hourly=temperature_2m,weather_code,wind_speed_10m'
        '&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,weather_code'
        '&forecast_days=10'
        '&timezone=Asia%2FDhaka';

    final weatherUrl = Uri.parse('https://api.open-meteo.com/v1/forecast$qs');

    final weatherRes = await http.get(weatherUrl);
    if (weatherRes.statusCode != 200) {
      throw Exception("Failed to load weather data");
    }

    final json = jsonDecode(weatherRes.body);
    return WeatherModel.fromJson(json, city: city, country: country);
  }
}
