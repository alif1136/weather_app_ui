import 'package:flutter/material.dart';
import '../data/repository/weather_repository.dart';
import '../data/models/weather_model.dart';
import '../theme/text_styles.dart';
import '../data/services/weather_service.dart';
import '../widgets/weather_header.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../data/repository/weather_repository_impl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherRepository _repo =
  WeatherRepositoryImpl(service: WeatherService());

  final TextEditingController _latCtrl =
  TextEditingController(text: '23.8103');
  final TextEditingController _lonCtrl =
  TextEditingController(text: '90.4125');


  WeatherModel? _weather;
  bool _loading = false;
  String? _error;

  // Central icon mapping (HomeScreen chooses icons for all UI)
  IconData _mapIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code == 1 || code == 2) return Icons.sunny; // fallback but Icons.sunny exists from Material 3; if not, will map to cloud
    if (code == 3) return Icons.cloud;
    if (code >= 45 && code <= 48) return Icons.foggy;
    if (code >= 51 && code <= 57) return Icons.grain;
    if (code >= 61 && code <= 67) return Icons.umbrella;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.beach_access;
    if (code >= 95) return Icons.thunderstorm;
    return Icons.cloud_queue;
  }

  String _mapCondition(int code) {
    if (code == 0) return 'Clear';
    if (code == 1 || code == 2) return 'Partly Cloudy';
    if (code == 3) return 'Cloudy';
    if (code >= 45 && code <= 48) return 'Fog';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain shower';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
  }

  Future<void> _search() async {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lon = double.tryParse(_lonCtrl.text.trim());
    if (lat == null || lon == null) {
      setState(() => _error = 'Enter valid latitude & longitude');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _weather = null;
    });

    try {
      final w = await _repo.getWeather(lat: lat, lon: lon);
      setState(() {
        _weather = w;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load weather';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // helper to build hourly subset (next 12 hours)
  List<HourlyWeather> _nextHourly(int count) {
    if (_weather == null) return [];
    final list = _weather!.hourly;
    // find index of current hour approximate
    final now = DateTime.now();
    int idx = list.indexWhere((h) => DateTime.tryParse(h.time)?.hour == now.hour);
    if (idx < 0) idx = 0;
    final end = (idx + count) < list.length ? (idx + count) : list.length;
    return list.sublist(idx, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 44),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    // Latitude input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _latCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Latitude',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Longitude input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _lonCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Longitude',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _search,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                        child: const Text('Get Weather'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              if (_loading) const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.white),
              ),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                ),

              if (_weather != null)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10, bottom: 36),
                    children: [
                      // Header: centered layout
                      WeatherHeader(
                        temperature: _weather!.current.temperature,
                        icon: _mapIcon(_weather!.current.weatherCode),
                        city: _weather!.city,
                        country: _weather!.country,
                        condition: _mapCondition(_weather!.current.weatherCode),
                        feelsLike: _weather!.current.temperature, // Open-Meteo doesn't have feels_like: reuse
                      ),
                      const SizedBox(height: 18),

                      // Hourly section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('Hourly Forecast', style: TextStyles.sectionTitle),
                      ),
                      const SizedBox(height: 10),
                      HourlyForecast(hourly: _nextHourly(12), mapIcon: _mapIcon),
                      const SizedBox(height: 18),

                      // Daily section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text('10-Day Forecast', style: TextStyles.sectionTitle),
                      ),
                      const SizedBox(height: 10),
                      DailyForecast(daily: _weather!.daily, mapIcon: _mapIcon),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
