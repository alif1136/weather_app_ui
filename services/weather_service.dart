import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  /// 1) Geocoding API → returns lat/lon + optional name
  Future<Map<String, double>> fetchCityCoordinates(String city) async {
    final encoded = Uri.encodeComponent(city);
    final url =
        "https://geocoding-api.open-meteo.com/v1/search?name=$encoded&count=1&format=json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["results"] != null && data["results"].isNotEmpty) {
        final r = data["results"][0];
        return {
          "lat": (r["latitude"] as num).toDouble(),
          "lon": (r["longitude"] as num).toDouble(),
        };
      }
    }

    throw Exception("City not found");
  }

  /// 2) Weather API
  Future<WeatherData> fetchWeather(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?"
        "latitude=$lat&longitude=$lon"
        "&current=temperature_2m,weather_code,wind_speed_10m"
        "&hourly=temperature_2m,weather_code,wind_speed_10m"
        "&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset"
        "&forecast_days=10"
        "&timezone=Asia%2FDhaka";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherData.fromJson(data);
    }

    throw Exception("Weather API error");
  }
}
