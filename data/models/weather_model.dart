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

  factory WeatherModel.fromJson(
      Map<String, dynamic> json, {
        required String city,
        required String country,
      }) {
    // ------- Current -------
    final currentJson = json['current'] ?? {};
    final current = CurrentWeather(
      temperature: (currentJson['temperature_2m'] ?? 0).toDouble(),
      weatherCode: currentJson['weather_code'] ?? 0,
      windSpeed: (currentJson['wind_speed_10m'] ?? 0).toDouble(),
    );

    // ------- Hourly -------
    final hourly = <HourlyWeather>[];
    if (json['hourly'] != null) {
      List times = json['hourly']['time'];
      List temps = json['hourly']['temperature_2m'];
      List codes = json['hourly']['weather_code'];
      List winds = json['hourly']['wind_speed_10m'];

      for (int i = 0; i < times.length; i++) {
        hourly.add(HourlyWeather(
          time: times[i],
          temperature: temps[i].toDouble(),
          weatherCode: codes[i],
          windSpeed: winds[i].toDouble(),
        ));
      }
    }

    // ------- Daily -------
    final daily = <DailyWeather>[];
    if (json['daily'] != null) {
      List times = json['daily']['time'];
      List maxT = json['daily']['temperature_2m_max'];
      List minT = json['daily']['temperature_2m_min'];
      List sunrise = json['daily']['sunrise'];
      List sunset = json['daily']['sunset'];
      List codes = json['daily']['weather_code'];

      for (int i = 0; i < times.length; i++) {
        daily.add(DailyWeather(
          date: times[i],
          maxTemp: maxT[i].toDouble(),
          minTemp: minT[i].toDouble(),
          sunrise: sunrise[i],
          sunset: sunset[i],
          weatherCode: codes[i],
        ));
      }
    }

    return WeatherModel(
      city: city,
      country: country,
      current: current,
      hourly: hourly,
      daily: daily,
    );
  }
}

class CurrentWeather {
  final double temperature;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
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
