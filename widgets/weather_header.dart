import 'package:flutter/material.dart';
import '../theme/text_styles.dart';
import '../theme/app_colors.dart';

class WeatherHeader extends StatelessWidget {
  final String cityCountry;
  final double temp;
  final int conditionCode;
  final String conditionText;
  final double high;
  final double low;

  const WeatherHeader({
    super.key,
    required this.cityCountry,
    required this.temp,
    required this.conditionCode,
    required this.conditionText,
    required this.high,
    required this.low,
  });

  String emojiFor(int code) {
    if (code == 0) return '☀️';
    if ([1, 2, 3].contains(code)) return '🌤';
    if ([45, 48].contains(code)) return '🌫';
    if ([51, 53, 55, 56, 57].contains(code)) return '🌦';
    if ([61, 63, 65, 66, 67].contains(code)) return '🌧';
    if ([71, 73, 75, 77].contains(code)) return '❄️';
    if ([80, 81, 82].contains(code)) return '⛈';
    if ([95, 96, 99].contains(code)) return '🌩';
    return '❔';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MY LOCATION', style: TextStyles.headerLabel),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(cityCountry, style: TextStyles.location),
            const Icon(Icons.more_horiz, color: Colors.white54),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('${temp.toStringAsFixed(0)}°', style: TextStyles.temperatureBig),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conditionText, style: TextStyles.condition),
                const SizedBox(height: 4),
                Text('H:${high.toStringAsFixed(0)}°  L:${low.toStringAsFixed(0)}°',
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
            const Spacer(),
            Text(emojiFor(conditionCode), style: const TextStyle(fontSize: 30)),
          ],
        ),
      ],
    );
  }
}
