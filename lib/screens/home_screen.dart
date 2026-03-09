import 'package:flutter/material.dart';

import '../services/weather_service.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _getWeather() async {
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeatherByCity(city);

      if (!mounted) {
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WeatherScreen(weather: weather)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F9E9A), Color(0xFF1BC9C2)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double widthScale = (constraints.maxWidth / 390).clamp(
                0.82,
                1.0,
              );
              final double heightScale = (constraints.maxHeight / 844).clamp(
                0.82,
                1.0,
              );
              final double scale = (widthScale * heightScale).clamp(0.80, 1.0);

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22 * scale,
                    vertical: 24 * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.white,
                        size: 62 * scale,
                      ),
                      SizedBox(height: 14 * scale),
                      Text(
                        'SkyCast',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42 * scale,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: 8 * scale),
                      Text(
                        'Minimal weather forecasts for your city',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 34 * scale),
                      Container(
                        padding: EdgeInsets.all(22 * scale),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(26 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.14),
                              blurRadius: 20 * scale,
                              offset: Offset(0, 10 * scale),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Search Weather by City',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24 * scale,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 18 * scale),
                            TextField(
                              controller: _cityController,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _getWeather(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16 * scale,
                              ),
                              decoration: InputDecoration(
                                labelText: 'City Name',
                                labelStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14 * scale,
                                ),
                                prefixIcon: Icon(
                                  Icons.location_city_outlined,
                                  color: Colors.white,
                                  size: 22 * scale,
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    16 * scale,
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.35),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    16 * scale,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16 * scale),
                            SizedBox(
                              height: 54 * scale,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _getWeather,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF0D918D),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      40 * scale,
                                    ),
                                  ),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 22 * scale,
                                        height: 22 * scale,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Color(0xFF0D918D),
                                        ),
                                      )
                                    : Text(
                                        'Get Weather',
                                        style: TextStyle(
                                          fontSize: 17 * scale,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            if (_errorMessage != null) ...[
                              SizedBox(height: 14 * scale),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12 * scale,
                                  vertical: 10 * scale,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF7F1D1D,
                                  ).withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(
                                    12 * scale,
                                  ),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14 * scale,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
