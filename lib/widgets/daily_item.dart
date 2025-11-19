import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/weather_model.dart';
import '../theme/text_styles.dart';

class DailyItem extends StatelessWidget {
  final DailyWeather data;
  final IconData icon;

  const DailyItem({super.key, required this.data, required this.icon});

  String _dayLabel(String dateIso) {
    try {
      final dt = DateTime.parse(dateIso);
      return DateFormat.E().format(dt); // Mon, Tue...
    } catch (e) {
      return data.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratio = (data.maxTemp / (data.maxTemp + data.minTemp + 1)).clamp(0.05, 0.95);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(width: 64, child: Text(_dayLabel(data.date), style: TextStyles.smallBold)),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(height: 8, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8))),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(height: 8, decoration: BoxDecoration(color: Colors.yellowAccent, borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${data.maxTemp.round()}°', style: TextStyles.smallBold),
              Text('${data.minTemp.round()}°', style: TextStyles.small),
            ],
          ),
        ],
      ),
    );
  }
}
