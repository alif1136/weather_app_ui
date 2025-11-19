import 'package:flutter/material.dart';
import 'hourly_item.dart';
import '../data/models/weather_model.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecast({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: hourly
              .map((h) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: HourlyItem(hourly: h),
          ))
              .toList(),
        ),
      ),
    );
  }
}
