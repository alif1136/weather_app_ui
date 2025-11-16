String weatherIconForCode(int code) {
  // Open-Meteo weather codes mapping (common ones)
  if (code == 0) return 'assets/icons/sun.png';
  if ([1, 2, 3].contains(code)) return 'assets/icons/partly_cloudy.png';
  if ([45, 48].contains(code)) return 'assets/icons/fog.png';
  if ([51, 53, 55, 56, 57].contains(code)) return 'assets/icons/rain.png';
  if ([61, 63, 65, 66, 67].contains(code)) return 'assets/icons/rain.png';
  if ([71, 73, 75, 77].contains(code)) return 'assets/icons/snow.png';
  if ([80, 81, 82].contains(code)) return 'assets/icons/rain.png';
  if ([95, 96, 99].contains(code)) return 'assets/icons/thunder.png';
  return 'assets/icons/cloud.png';
}
