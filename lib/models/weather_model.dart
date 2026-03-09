class WeatherModel {
  final String cityName;
  final String location;
  final double temperatureCelsius;
  final String description;
  final int cloudCover;
  final int humidity;
  final double windSpeedMph;
  final int weatherCode;

  WeatherModel({
    required this.cityName,
    required this.location,
    required this.temperatureCelsius,
    required this.description,
    required this.cloudCover,
    required this.humidity,
    required this.windSpeedMph,
    required this.weatherCode,
  });
}
