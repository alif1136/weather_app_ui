import 'package:flutter/material.dart';
import 'weather_icons.dart';

class HourlyItem extends StatelessWidget {
  final String hour;
  final double temp;
  final int code;

  const HourlyItem({super.key, required this.hour, required this.temp, required this.code});

  @override
  Widget build(BuildContext context) {
    final iconPath = weatherIconForCode(code);
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(hour, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Image.asset(iconPath, width: 36, height: 36),
          const SizedBox(height: 8),
          Text('${temp.toStringAsFixed(0)}°', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
