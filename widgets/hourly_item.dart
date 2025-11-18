import 'package:flutter/material.dart';
import '../data/models/weather_model.dart';
import '../theme/text_styles.dart';

class HourlyItem extends StatelessWidget {
  final HourlyWeather data;
  final IconData icon;

  const HourlyItem({super.key, required this.data, required this.icon});

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h $ampm';
    } catch (e) {
      return data.time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatTime(data.time), style: TextStyles.small),
          const SizedBox(height: 8),
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 8),
          Text('${data.temperature.round()}°', style: TextStyles.smallBold),
        ],
      ),
    );
  }
}
