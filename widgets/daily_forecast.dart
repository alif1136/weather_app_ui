import 'package:flutter/material.dart';
import '../data/models/weather_model.dart';
import 'daily_item.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> daily;
  final IconData Function(int) mapIcon;

  const DailyForecast({super.key, required this.daily, required this.mapIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: daily.map((d) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DailyItem(data: d, icon: mapIcon(d.weatherCode)),
          );
        }).toList(),
      ),
    );
  }
}
