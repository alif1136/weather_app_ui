import 'package:flutter/material.dart';
import 'hourly_item.dart';

class HourlyForecast extends StatelessWidget {
  final List<String> times;
  final List<double> temps;
  final List<int> codes;
  final String Function(String) formatHour;

  const HourlyForecast({
    super.key,
    required this.times,
    required this.temps,
    required this.codes,
    required this.formatHour,
  });

  @override
  Widget build(BuildContext context) {
    final count = temps.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Now · Hourly', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final hourLabel = formatHour(times[index]);
              return HourlyItem(
                hour: hourLabel,
                temp: temps[index],
                code: codes[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
