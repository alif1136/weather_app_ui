import 'package:flutter/material.dart';
import '../data/models/weather_model.dart';
import '../theme/text_styles.dart';

class HourlyItem extends StatelessWidget {
  final HourlyWeather hourly;

  const HourlyItem({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          hourly.time,
          style: TextStyles.smallBold.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Icon(Icons.wb_sunny, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          "${hourly.temperature.toStringAsFixed(0)}°",
          style: TextStyles.smallBold.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
