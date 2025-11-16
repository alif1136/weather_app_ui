import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../widgets/search_input.dart';
import '../widgets/weather_header.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';





class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _service = WeatherService();
  WeatherData? _weather;
  String _city = 'Dhaka';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // initial load for Dhaka for demo
    _fetchByCity(_city);
  }

  Future<void> _fetchByCity(String city) async {
    setState(() {
      _loading = true;
      _error = null;
      _weather = null;
    });
    try {
      final coords = await _service.fetchCityCoordinates(city);
      if (coords == null) {
        setState(() {
          _error = 'City not found';
          _loading = false;
        });
        return;
      }
      final data = await _service.fetchWeather(coords['lat']!, coords['lon']!);
      setState(() {
        _weather = data;
        _city = city;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load weather';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String formatHour(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat.j().format(dt); // e.g., "1 AM"
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTop, AppColors.gradientBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchInput(
                  initialCity: _city,
                  onSearch: (value) {
                    _fetchByCity(value);
                  },
                ),
                const SizedBox(height: 14),
                // header area
                if (_loading)
                  const Center(child: CircularProgressIndicator(color: Colors.white))
                else if (_error != null)
                  Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                else if (_weather != null) ...[
                    WeatherHeader(
                      cityCountry: _city, // you can expand to show "Dhaka, Bangladesh"
                      temp: _weather!.currentTemp,
                      conditionCode: _weather!.weatherCode,
                      conditionText: _conditionText(_weather!.weatherCode),
                      high: _weather!.dailyMax.isNotEmpty ? _weather!.dailyMax[0] : 0,
                      low: _weather!.dailyMin.isNotEmpty ? _weather!.dailyMin[0] : 0,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Sunny conditions likely through today. Wind up to ${_weather!.windSpeed.toStringAsFixed(0)} km/h.',
                        style: TextStyles.cardText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    HourlyForecast(
                      times: _weather!.hourlyTime.take(24).toList(),
                      temps: _weather!.hourlyTemps.take(24).toList(),
                      codes: _weather!.hourlyCodes.take(24).toList(),
                      formatHour: formatHour,
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: DailyForecast(
                        dates: _weather!.dailyTime,
                        max: _weather!.dailyMax,
                        min: _weather!.dailyMin,
                        sunrise: _weather!.sunrise,
                        sunset: _weather!.sunset,
                        codes: _weather!.dailyCodes, // <-- pass daily codes here
                      ),
                    ),

                  ] else
                  // empty state
                    const Center(
                        child: Text(
                          'Enter city name (e.g., Dhaka) and press Go',
                          style: TextStyle(color: Colors.white70),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _conditionText(int code) {
    if (code == 0) return 'Clear';
    if ([1, 2, 3].contains(code)) return 'Mostly Sunny';
    if ([45, 48].contains(code)) return 'Fog';
    if ([51, 53, 55, 56, 57].contains(code)) return 'Drizzle';
    if ([61, 63, 65, 66, 67].contains(code)) return 'Rain';
    if ([71, 73, 75, 77].contains(code)) return 'Snow';
    if ([80, 81, 82].contains(code)) return 'Rain Showers';
    if ([95, 96, 99].contains(code)) return 'Thunderstorm';
    return 'Unknown';
  }
}
