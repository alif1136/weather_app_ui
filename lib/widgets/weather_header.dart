import 'package:flutter/material.dart';
import '../theme/text_styles.dart';

class WeatherHeader extends StatelessWidget {
  final double temperature;
  final IconData icon;
  final String city;
  final String country;
  final String condition;
  final double feelsLike;

  const WeatherHeader({
    super.key,
    required this.temperature,
    required this.icon,
    required this.city,
    required this.country,
    required this.condition,
    required this.feelsLike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${temperature.round()}°', style: TextStyles.tempLarge),
        const SizedBox(height: 8),
        Icon(icon, size: 72, color: Colors.white),
        const SizedBox(height: 10),
        Text('$city${country.isNotEmpty ? ', $country' : ''}', style: TextStyles.location, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(condition, style: TextStyles.condition),
        const SizedBox(height: 6),
        Text('Feels like ${feelsLike.round()}°', style: TextStyles.feelsLike),
      ],
    );
  }
}
