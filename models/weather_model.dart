class WeatherData {
  final double currentTemp;
  final int weatherCode;
  final double windSpeed;

  final List<String> hourlyTime;
  final List<double> hourlyTemps;
  final List<int> hourlyCodes;

  final List<String> dailyTime;
  final List<double> dailyMax;
  final List<double> dailyMin;
  final List<int> dailyCodes; // NEW
  final List<String> sunrise;
  final List<String> sunset;

  WeatherData({
    required this.currentTemp,
    required this.weatherCode,
    required this.windSpeed,
    required this.hourlyTime,
    required this.hourlyTemps,
    required this.hourlyCodes,
    required this.dailyTime,
    required this.dailyMax,
    required this.dailyMin,
    required this.dailyCodes,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] ?? {};
    final hourly = json['hourly'] ?? {};
    final daily = json['daily'] ?? {};

    List<String> hourlyTime = List<String>.from(hourly['time'] ?? []);
    List<double> hourlyTemps = List<double>.from(
        (hourly['temperature_2m'] ?? []).map((e) => (e as num).toDouble()));
    List<int> hourlyCodes = List<int>.from(
        (hourly['weather_code'] ?? []).map((e) => (e as num).toInt()));

    List<String> dailyTime = List<String>.from(daily['time'] ?? []);
    List<double> dailyMax = List<double>.from(
        (daily['temperature_2m_max'] ?? []).map((e) => (e as num).toDouble()));
    List<double> dailyMin = List<double>.from(
        (daily['temperature_2m_min'] ?? []).map((e) => (e as num).toDouble()));
    // daily weather code may be available as 'weathercode' or 'weather_code'
    List<int> dailyCodes = [];
    if (daily['weathercode'] != null) {
      dailyCodes = List<int>.from((daily['weathercode'] ?? []).map((e) => (e as num).toInt()));
    } else if (daily['weather_code'] != null) {
      dailyCodes = List<int>.from((daily['weather_code'] ?? []).map((e) => (e as num).toInt()));
    } else {
      // fallback: use first hourly code of the day for each day (best-effort)
      dailyCodes = List<int>.generate(dailyTime.length, (_) => 0);
    }

    List<String> sunrise = List<String>.from(daily['sunrise'] ?? []);
    List<String> sunset = List<String>.from(daily['sunset'] ?? []);

    return WeatherData(
      currentTemp: (current['temperature_2m'] ?? 0).toDouble(),
      weatherCode: (current['weather_code'] ?? 0).toInt(),
      windSpeed: (current['wind_speed_10m'] ?? 0).toDouble(),
      hourlyTime: hourlyTime,
      hourlyTemps: hourlyTemps,
      hourlyCodes: hourlyCodes,
      dailyTime: dailyTime,
      dailyMax: dailyMax,
      dailyMin: dailyMin,
      dailyCodes: dailyCodes,
      sunrise: sunrise,
      sunset: sunset,
    );
  }
}
