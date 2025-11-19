// lib/data/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getGeoLocation(String city) async {
    final url =
        "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&format=json";

    final res = await http.get(Uri.parse(url));
    return json.decode(res.body);
  }

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon"
        "&current=temperature_2m,weather_code,wind_speed_10m"
        "&hourly=temperature_2m,weather_code"
        "&daily=temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset"
        "&forecast_days=10&timezone=Asia%2FDhaka";

    final res = await http.get(Uri.parse(url));
    return json.decode(res.body);
  }
}
