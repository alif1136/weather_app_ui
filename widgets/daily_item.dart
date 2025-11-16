import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'weather_icons.dart';

class DailyItem extends StatelessWidget {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String sunrise;
  final String sunset;
  final int code; // NEW

  const DailyItem({
    super.key,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.sunrise,
    required this.sunset,
    required this.code,
  });

  String dayLabel(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return DateFormat.E().format(dt); // Mon, Tue...
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = ((maxTemp - minTemp) / (maxTemp + 0.0001)).abs().clamp(0.05, 1.0);
    final icon = weatherIconForCode(code);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(dayLabel(date), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          Image.asset(icon, width: 26, height: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                // track bar
                Container(
                  height: 10,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percent,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(color: const Color(0xFFFFD54F), borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${minTemp.toStringAsFixed(0)}°', style: const TextStyle(color: Colors.white70)),
                    Text('${maxTemp.toStringAsFixed(0)}°', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('🌅 ${sunrise.split('T').length > 1 ? sunrise.split('T')[1] : sunrise}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 6),
              Text('🌇 ${sunset.split('T').length > 1 ? sunset.split('T')[1] : sunset}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}
