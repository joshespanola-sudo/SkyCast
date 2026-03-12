import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const Duration _timeout = Duration(seconds: 10);

  Future<WeatherModel> fetchWeatherByCity(String city) async {
    try {
      // 1) Get latitude and longitude from city name.
      final geocodingUri = Uri.https(
        'geocoding-api.open-meteo.com',
        '/v1/search',
        {'name': city, 'count': '1', 'language': 'en', 'format': 'json'},
      );

      final geocodingResponse = await http
          .get(geocodingUri)
          .timeout(
            _timeout,
            onTimeout: () => throw Exception(
              'Connection timeout. Please check your internet connection.',
            ),
          );

      if (geocodingResponse.statusCode != 200) {
        throw Exception('Failed to search city. Please try again.');
      }

      final Map<String, dynamic> geocodingData =
          jsonDecode(geocodingResponse.body) as Map<String, dynamic>;
      final List<dynamic>? results = geocodingData['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) {
        throw Exception('City not found. Please enter a valid city name.');
      }

      final Map<String, dynamic> cityData =
          results.first as Map<String, dynamic>;
      final double lat = (cityData['latitude'] as num).toDouble();
      final double lon = (cityData['longitude'] as num).toDouble();
      final String cityName = cityData['name'] as String;
      final String location =
          (cityData['admin1'] ?? cityData['country'] ?? '') as String;

      // 2) Fetch current weather using the coordinates.
      final forecastUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'daily': 'weather_code',
        'current':
            'temperature_2m,relative_humidity_2m,cloud_cover,wind_speed_10m,weather_code',
        'wind_speed_unit': 'mph',
        'timezone': 'auto',
      });

      final forecastResponse = await http
          .get(forecastUri)
          .timeout(
            _timeout,
            onTimeout: () => throw Exception(
              'Connection timeout. Please check your internet connection.',
            ),
          );

      if (forecastResponse.statusCode != 200) {
        throw Exception('Failed to fetch weather data. Please try again.');
      }

      final Map<String, dynamic> forecastData =
          jsonDecode(forecastResponse.body) as Map<String, dynamic>;
      final Map<String, dynamic>? current =
          forecastData['current'] as Map<String, dynamic>?;

      if (current == null) {
        throw Exception('Weather data is unavailable for this location.');
      }

      final int weatherCode = (current['weather_code'] as num?)?.toInt() ?? 0;

      return WeatherModel(
        cityName: cityName,
        location: location,
        temperatureCelsius: (current['temperature_2m'] as num).toDouble(),
        description: _descriptionFromCode(weatherCode),
        cloudCover: (current['cloud_cover'] as num?)?.toInt() ?? 0,
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        windSpeedMph: (current['wind_speed_10m'] as num).toDouble(),
        weatherCode: weatherCode,
      );
    } on TimeoutException catch (_) {
      throw Exception(
        'Request timed out. Please check your internet connection.',
      );
    } on SocketException catch (e) {
      // DNS lookup failures or connection refused
      throw Exception(
        'Unable to connect to weather service. Please try again.',
      );
    } catch (e) {
      // Log the actual error for debugging
      print('Weather service error: $e');
      throw Exception('Failed to fetch weather. Please try again.');
    }
  }
}

String _descriptionFromCode(int code) {
  switch (code) {
    case 0:
      return 'Clear sky';
    case 1:
    case 2:
    case 3:
      return 'Partly cloudy';
    case 45:
    case 48:
      return 'Fog';
    case 51:
    case 53:
    case 55:
      return 'Drizzle';
    case 61:
    case 63:
    case 65:
      return 'Rain';
    case 71:
    case 73:
    case 75:
      return 'Snow';
    case 80:
    case 81:
    case 82:
      return 'Rain showers';
    case 95:
    case 96:
    case 99:
      return 'Thunderstorm';
    default:
      return 'Unknown weather';
  }
}
