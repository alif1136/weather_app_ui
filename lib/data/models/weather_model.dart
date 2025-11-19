// lib/data/models/weather_model.dart

class WeatherModel {
  final String city;
  final String country;
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherModel({
    required this.city,
    required this.country,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  /// Create WeatherModel from Open-Meteo response.
  /// Accepts either the raw API response or a minimal combined map with keys:
  /// 'current', 'hourly', 'daily'
  factory WeatherModel.fromJson(Map<String, dynamic> json, {required String city, required String country}) {
    // current
    final Map<String, dynamic> currentJson = json['current'] ?? json['current_weather'] ?? {};

    // try multiple possible keys for temperature and codes
    double curTemp = 0.0;
    int curCode = 0;
    double curWind = 0.0;
    String curTime = DateTime.now().toIso8601String();

    if (currentJson.isNotEmpty) {
      if (currentJson.containsKey('temperature_2m')) curTemp = (currentJson['temperature_2m'] as num).toDouble();
      else if (currentJson.containsKey('temperature')) curTemp = (currentJson['temperature'] as num).toDouble();

      if (currentJson.containsKey('weather_code')) curCode = (currentJson['weather_code'] as num).toInt();
      else if (currentJson.containsKey('weathercode')) curCode = (currentJson['weathercode'] as num).toInt();

      if (currentJson.containsKey('wind_speed_10m')) curWind = (currentJson['wind_speed_10m'] as num).toDouble();
      else if (currentJson.containsKey('windspeed')) curWind = (currentJson['windspeed'] as num).toDouble();

      if (currentJson.containsKey('time')) curTime = currentJson['time'].toString();
    } else {
      // fallback: maybe use first hourly item
      try {
        final hourlyTemp = (json['hourly']['temperature_2m'][0] as num).toDouble();
        curTemp = hourlyTemp;
        curTime = json['hourly']['time'][0].toString();
      } catch (_) {}
    }

    final current = CurrentWeather(
      temperature: curTemp,
      weatherCode: curCode,
      windSpeed: curWind,
      time: curTime,
    );

    // hourly
    final List<HourlyWeather> hourlyList = [];
    if (json['hourly'] != null) {
      final hourlyJson = json['hourly'];
      final List times = List.from(hourlyJson['time'] ?? []);
      final List temps = List.from(hourlyJson['temperature_2m'] ?? []);
      final List codes = List.from(hourlyJson['weather_code'] ?? []);
      final List winds = List.from(hourlyJson['wind_speed_10m'] ?? List.filled(times.length, 0));

      for (int i = 0; i < times.length; i++) {
        final t = times[i].toString();
        final temp = (i < temps.length) ? (temps[i] as num).toDouble() : 0.0;
        final code = (i < codes.length) ? (codes[i] as num).toInt() : 0;
        final wind = (i < winds.length) ? (winds[i] as num).toDouble() : 0.0;
        hourlyList.add(HourlyWeather(time: t, temperature: temp, weatherCode: code, windSpeed: wind));
      }
    }

    // daily
    final List<DailyWeather> dailyList = [];
    if (json['daily'] != null) {
      final dailyJson = json['daily'];
      final List times = List.from(dailyJson['time'] ?? []);
      final List maxs = List.from(dailyJson['temperature_2m_max'] ?? []);
      final List mins = List.from(dailyJson['temperature_2m_min'] ?? []);
      final List sunr = List.from(dailyJson['sunrise'] ?? List.filled(times.length, ''));
      final List suns = List.from(dailyJson['sunset'] ?? List.filled(times.length, ''));
      final List codes = List.from(dailyJson['weather_code'] ?? List.filled(times.length, 0));

      for (int i = 0; i < times.length; i++) {
        final date = times[i].toString();
        final mx = (i < maxs.length) ? (maxs[i] as num).toDouble() : 0.0;
        final mn = (i < mins.length) ? (mins[i] as num).toDouble() : 0.0;
        final sr = (i < sunr.length) ? sunr[i].toString() : '';
        final ss = (i < suns.length) ? suns[i].toString() : '';
        final code = (i < codes.length) ? (codes[i] as num).toInt() : 0;
        dailyList.add(DailyWeather(date: date, maxTemp: mx, minTemp: mn, sunrise: sr, sunset: ss, weatherCode: code));
      }
    }

    return WeatherModel(
      city: city,
      country: country,
      current: current,
      hourly: hourlyList,
      daily: dailyList,
    );
  }
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final double windSpeed;
  final String time;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.time,
  });
}

class HourlyWeather {
  final String time;
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });
}

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String sunrise;
  final String sunset;
  final int weatherCode;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.sunrise,
    required this.sunset,
    required this.weatherCode,
  });
}
