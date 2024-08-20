import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast_app/cards/hourly-weather-card.dart';
import 'package:weather_forecast_app/cards/weather-card.dart';
import 'api/weather.dart';
import 'geo/geo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _currentWeather;
  Map<String, dynamic>? _forecast;
  String _error = '';
  bool _isLoading = true;
  Map<String, List<Map<String, dynamic>>> _forecastByDay = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  void _getCurrentLocationWeather() async {
    try {
      final position = await getCurrentLocation();
      final forecast = await fetchWeatherForecast(
          position.latitude.toString(), position.longitude.toString());
      Map<String, List<Map<String, dynamic>>> groupedData = {};
      for (var forecast in forecast!['list']) {
        final date = DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000));
        if (!groupedData.containsKey(date)) {
          groupedData[date] = [];
        }
        groupedData[date]!.add(forecast);
      }
      setState(() {
        _currentWeather = forecast['list'][0];
        _forecast = forecast;
        _error = '';
        _isLoading = false;
        _forecastByDay = groupedData;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              if (_isLoading) const CircularProgressIndicator(),
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),
              if (_currentWeather != null && _forecast != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherCard(weather: _currentWeather!),
                    const SizedBox(height: 10),
                    const Text('3-Day Forecast',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ..._buildForecastList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildForecastList() {
    List<Widget> forecastWidgets = [];
    String? previousDate;
    bool isFirstDay = true;

    _forecastByDay.forEach((date, dayWeatherList) {
      if (isFirstDay) {
        isFirstDay = false;
        return;
      }
      forecastWidgets.add(
        Text(
          DateFormat('EEEE, dd MMMM').format(DateTime.parse(date)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      );

      forecastWidgets.add(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: dayWeatherList.map((weather) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HourlyWeatherCard(weather: weather),
              );
            }).toList(),
          ),
        ),
      );
      forecastWidgets.add(const SizedBox(height: 10));
    });

    return forecastWidgets;
  }
}
