import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/weather_model.dart';
import '../data/repository/weather_repository_impl.dart';
import '../data/services/weather_service.dart';
import '../theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityCtrl =
  TextEditingController(text: 'Dhaka');

  late final WeatherRepositoryImpl _repo;

  WeatherModel? _weather;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repo = WeatherRepositoryImpl(WeatherService());
  }

  IconData _mapIcon(int code) {
    if ([0, 1].contains(code)) return Icons.wb_sunny_rounded;
    if ([2, 3].contains(code)) return Icons.cloud_rounded;
    if ([45, 48].contains(code)) return Icons.blur_on_rounded;
    if ([51, 53, 55, 56, 57].contains(code)) return Icons.grain_rounded;
    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code))
      return Icons.umbrella_rounded;
    if ([71, 73, 75, 77, 85, 86].contains(code))
      return Icons.ac_unit_rounded;
    if ([95, 96, 99].contains(code))
      return Icons.thunderstorm_rounded;
    return Icons.help_outline_rounded;
  }

  String _mapCondition(int code) {
    if ([0, 1].contains(code)) return 'Clear Sky';
    if ([2, 3].contains(code)) return 'Cloudy';
    if ([45, 48].contains(code)) return 'Fog';
    if ([51, 53, 55].contains(code)) return 'Drizzle';
    if ([61, 63, 65].contains(code)) return 'Rain';
    if ([71, 73, 75].contains(code)) return 'Snow';
    if ([95, 96, 99].contains(code)) return 'Thunderstorm';
    return 'Unknown';
  }

  List<HourlyWeather> _nextHourly(int n) {
    if (_weather == null) return [];
    final list = _weather!.hourly;
    final now = DateTime.now();

    int idx = list.indexWhere((h) {
      final dt = DateTime.tryParse(h.time);
      if (dt == null) return false;
      return dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day &&
          dt.hour == now.hour;
    });

    if (idx == -1) idx = 0;

    final end = (idx + n) < list.length ? (idx + n) : list.length;
    return list.sublist(idx, end);
  }

  Future<void> _search() async {
    final city = _cityCtrl.text.trim();
    if (city.isEmpty) {
      setState(() => _error = 'Please enter a city name');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _weather = null;
    });

    try {
      final geoJson = await _repo.fetchGeo(city);

      double lat;
      double lon;
      String name = city;
      String country = '';

      if (geoJson.containsKey('lat')) {
        lat = (geoJson['lat'] as num).toDouble();
        lon = (geoJson['lon'] as num).toDouble();
        name = geoJson['name'] ?? city;
        country = geoJson['country'] ?? '';
      } else if (geoJson.containsKey('results')) {
        final r = geoJson['results'][0];
        lat = (r['latitude'] as num).toDouble();
        lon = (r['longitude'] as num).toDouble();
        name = r['name'] ?? city;
        country = r['country'] ?? '';
      } else {
        throw Exception('Geo format unknown');
      }

      final weatherJson = await _repo.fetchWeather(lat, lon);
      final model = WeatherModel.fromJson(
        weatherJson,
        city: name,
        country: country,
      );

      setState(() => _weather = model);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  String _formatHour(String iso) {
    try {
      return DateFormat.j().format(DateTime.parse(iso).toLocal());
    } catch (e) {
      return iso;
    }
  }

  String _formatDate(String iso) {
    try {
      return DateFormat.yMMMd().format(DateTime.parse(iso).toLocal());
    } catch (e) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topGradient = const Color(0xFF8EC5FC);
    final bottomGradient = const Color(0xFFE0C3FC);

    final todayMax = _weather?.daily.isNotEmpty ?? false
        ? _weather!.daily[0].maxTemp
        : null;
    final todayMin = _weather?.daily.isNotEmpty ?? false
        ? _weather!.daily[0].minTemp
        : null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [topGradient, bottomGradient],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white54),
                        color: Colors.white.withOpacity(0.08),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.my_location,
                              color: Colors.white70),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: TextField(
                              controller: _cityCtrl,
                              style:
                              const TextStyle(color: Colors.white),
                              decoration:
                              const InputDecoration.collapsed(
                                  hintText: "Search Location",
                                  hintStyle: TextStyle(
                                      color: Colors.white70)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.white.withOpacity(0.18),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Go"),
                    )
                  ],
                ),
              ),

              /// EVERYTHING BELOW IS NOW SCROLLABLE
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      /// LOCATION LABEL
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _weather != null
                                ? '${_weather!.city}, ${_weather!.country}'
                                : "Your Location",
                            style: TextStyles.location
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),

                      /// MAIN CARD
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        child: _buildMainCard(todayMax, todayMin),
                      ),

                      const SizedBox(height: 12),

                      /// HOURLY
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildHourlyCard(),
                      ),

                      const SizedBox(height: 14),

                      /// DAILY 10-DAYS
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 18),
                        child: _buildDailyCard(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _buildMainCard(double? todayMax, double? todayMin) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _weather != null
                ? _formatDate(_weather!.current.time)
                : '',
            style: TextStyles.small.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      _weather != null
                          ? '${_weather!.current.temperature.round()}'
                          : '--',
                      style: TextStyles.tempLarge
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text('°C',
                        style: TextStyles.small
                            .copyWith(color: Colors.white70))
                  ],
                ),
              ),
              Column(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      _weather != null
                          ? _mapCondition(
                          _weather!.current.weatherCode)
                          : '',
                      style: TextStyles.condition
                          .copyWith(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_weather != null)
                    Icon(
                      _mapIcon(_weather!.current.weatherCode),
                      size: 28,
                      color: Colors.white,
                    ),
                ],
              )
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statChip(Icons.arrow_upward,
                  todayMax != null ? todayMax.toStringAsFixed(1) : '--'),
              _statChip(Icons.arrow_downward,
                  todayMin != null ? todayMin.toStringAsFixed(1) : '--'),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            _weather != null
                ? '${_mapCondition(_weather!.current.weatherCode)} — Wind ${_weather!.current.windSpeed.toStringAsFixed(1)} km/h'
                : '',
            style: TextStyles.small.copyWith(color: Colors.white70),
          )
        ],
      ),
    );
  }

  Widget _buildHourlyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hourly Forecast',
            style:
            TextStyles.sectionTitle.copyWith(color: Colors.white)),
        const SizedBox(height: 10),
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
          ),
          child: _weather == null
              ? Center(
            child: Text('No data',
                style: TextStyles.small
                    .copyWith(color: Colors.white70)),
          )
              : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) =>
                _hourlyTile(_nextHourly(12)[i]),
            separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
            itemCount: _nextHourly(12).length,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("10 Days Forecast",
            style:
            TextStyles.sectionTitle.copyWith(color: Colors.white)),
        const SizedBox(height: 10),
        if (_weather == null) Container()
        else
          Column(
            children: _weather!.daily
                .map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _dailyTile(d),
            ))
                .toList(),
          ),
      ],
    );
  }

  // mini widgets
  Widget _statChip(IconData icon, String label) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(label,
              style:
              TextStyles.small.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _hourlyTile(HourlyWeather h) {
    return Container(
      width: 78,
      padding:
      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatHour(h.time),
              style:
              TextStyles.small.copyWith(color: Colors.white70)),
          const SizedBox(height: 6),
          Icon(_mapIcon(h.weatherCode),
              color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text('${h.temperature.round()}°',
              style: TextStyles.smallBold
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _dailyTile(DailyWeather d) {
    final ratio =
    (d.maxTemp / (d.maxTemp + d.minTemp + 1)).clamp(0.05, 0.95);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              DateFormat.E()
                  .format(DateTime.parse(d.date)),
              style: TextStyles.small.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Icon(_mapIcon(d.weatherCode), color: Colors.white),
          const SizedBox(width: 12),

          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8)),
                ),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${d.maxTemp.round()}°',
                  style: TextStyles.smallBold
                      .copyWith(color: Colors.white)),
              Text('${d.minTemp.round()}°',
                  style: TextStyles.small
                      .copyWith(color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }
}
