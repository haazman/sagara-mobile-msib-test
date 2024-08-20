import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

const String apiKey = '47c5ae6bba9d4efd0b87a7a240945cdd';
const String baseUrl = 'https://api.openweathermap.org/data/2.5';

final Dio dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  queryParameters: {'appid': apiKey, 'units': 'metric'},
));

Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
  final response = await dio.get('/weather', queryParameters: {'q': city});
  return response.data;
}

Future<Map<String, dynamic>> fetchWeatherForecast(String lat, String lon) async {
  final response = await dio.get('/forecast', queryParameters: {
    'lat': lat,
    'lon': lon,
    'cnt': 25
  });
  return response.data;
}


