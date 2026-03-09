import 'package:flutter/material.dart';

import '../models/weather_model.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherModel weather;

  const WeatherScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final String subtitle = weather.location.isEmpty
        ? _formattedDate()
        : '${weather.location}, ${_formattedDate()}';

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
                0.78,
                1.0,
              );
              final double scale = (widthScale * heightScale).clamp(0.78, 1.0);

              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: constraints.maxHeight * 0.30,
                    left: -40,
                    right: -40,
                    child: Container(
                      height: constraints.maxHeight * 0.20,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(120 * scale),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      24 * scale,
                      20 * scale,
                      24 * scale,
                      28 * scale,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _circleAction(
                                icon: Icons.arrow_back,
                                size: 52 * scale,
                                iconSize: 24 * scale,
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 24 * scale),
                          Text(
                            weather.cityName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36 * scale,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 6 * scale),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 26 * scale),
                          Icon(
                            _iconFromWeatherCode(weather.weatherCode),
                            size: 76 * scale,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8 * scale),
                          Text(
                            '${weather.temperatureCelsius.round()}°',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 110 * scale,
                              height: 0.95,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            weather.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 26 * scale),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16 * scale,
                              vertical: 18 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(24 * scale),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 18 * scale,
                                  offset: Offset(0, 8 * scale),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _weatherStat(
                                    Icons.cloud_outlined,
                                    '${weather.cloudCover}%',
                                    'Cloud',
                                    iconSize: 28 * scale,
                                    valueFontSize: 18 * scale,
                                    labelFontSize: 13 * scale,
                                  ),
                                ),
                                Expanded(
                                  child: _weatherStat(
                                    Icons.water_drop_outlined,
                                    '${weather.humidity}%',
                                    'Humidity',
                                    iconSize: 28 * scale,
                                    valueFontSize: 18 * scale,
                                    labelFontSize: 13 * scale,
                                  ),
                                ),
                                Expanded(
                                  child: _weatherStat(
                                    Icons.air,
                                    '${weather.windSpeedMph.toStringAsFixed(0)} mph',
                                    'Wind',
                                    iconSize: 28 * scale,
                                    valueFontSize: 18 * scale,
                                    labelFontSize: 13 * scale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12 * scale),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formattedDate() {
    final DateTime now = DateTime.now();
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${now.day} ${months[now.month - 1]}';
  }

  Widget _weatherStat(
    IconData icon,
    String value,
    String label, {
    required double iconSize,
    required double valueFontSize,
    required double labelFontSize,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: iconSize),
        SizedBox(height: iconSize * 0.28),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: valueFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: labelFontSize * 0.15),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: labelFontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _circleAction({
    required IconData icon,
    required double size,
    required double iconSize,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14 * (size / 52),
              offset: Offset(0, 6 * (size / 52)),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

  IconData _iconFromWeatherCode(int code) {
    if (code == 0) {
      return Icons.wb_sunny;
    }
    if (code >= 1 && code <= 3) {
      return Icons.cloud_queue;
    }
    if (code == 45 || code == 48) {
      return Icons.foggy;
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return Icons.grain;
    }
    if (code >= 71 && code <= 77) {
      return Icons.ac_unit;
    }
    if (code >= 95 && code <= 99) {
      return Icons.thunderstorm;
    }
    return Icons.cloud;
  }
}
