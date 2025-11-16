import 'package:flutter/material.dart';
import 'daily_item.dart';

class DailyForecast extends StatelessWidget {
  final List<String> dates;
  final List<double> max;
  final List<double> min;
  final List<String> sunrise;
  final List<String> sunset;
  final List<int> codes; // NEW

  const DailyForecast({
    super.key,
    required this.dates,
    required this.max,
    required this.min,
    required this.sunrise,
    required this.sunset,
    required this.codes,
  });

  @override
  Widget build(BuildContext context) {
    final count = max.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('10 Days Forecast', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: count,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final date = dates[index];
              final code = (codes.length > index) ? codes[index] : 0;
              return DailyItem(
                date: date,
                maxTemp: max[index],
                minTemp: min[index],
                sunrise: sunrise[index],
                sunset: sunset[index],
                code: code,
              );
            },
          ),
        ),
      ],
    );
  }
}
