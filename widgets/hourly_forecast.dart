import 'package:flutter/material.dart';
import '../data/models/weather_model.dart';
import 'hourly_item.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourly;
  final IconData Function(int) mapIcon;

  const HourlyForecast({super.key, required this.hourly, required this.mapIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final h = hourly[index];
          return HourlyItem(data: h, icon: mapIcon(h.weatherCode));
        },
      ),
    );
  }
}
