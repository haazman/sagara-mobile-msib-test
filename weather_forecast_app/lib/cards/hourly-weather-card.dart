import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyWeatherCard extends StatelessWidget {
  final Map<String, dynamic> weather;

  HourlyWeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000);
    final String timeFormatted = DateFormat('HH:mm').format(dateTime);
    final double temperature = weather['main']['temp'];
    final String weatherIcon = weather['weather'][0]['icon'];

    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${temperature.toStringAsFixed(0)}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.network(
            'http://openweathermap.org/img/wn/$weatherIcon@2x.png',
            width: 40,
            height: 40,
            color: Colors.white,
          ),
          SizedBox(height: 8.0),
          Text(
            timeFormatted,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
