import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weather;

  WeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    // Extracting relevant data from the weather map
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000);
    final String dateFormatted = DateFormat('EEEE, dd MMM').format(dateTime);
    final String year = DateFormat('yyyy').format(dateTime);
    final String location = weather.containsKey('name')
        ? '${weather['name']}, ${weather['sys']['country']}'
        : '';
    final double temperature = weather['main']['temp'];
    final double minTemp = weather['main']['temp_min'];
    final double maxTemp = weather['main']['temp_max'];
    final String weatherIcon = weather['weather'][0]['icon'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date, location and temperature information
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormatted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '${maxTemp.toStringAsFixed(1)}° | ${minTemp.toStringAsFixed(1)}°',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Image.network(
            'http://openweathermap.org/img/wn/$weatherIcon@2x.png',
            width: 60,
            height: 60,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
