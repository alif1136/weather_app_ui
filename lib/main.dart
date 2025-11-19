import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:weather_app_ui/theme/text_styles.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open-Meteo Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(bodyMedium: TextStyles.small),
      ),
      home: const HomeScreen(),
    );
  }
}
