import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/Model/model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    // Corrected URL with proper query parameters
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error fetching weather data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // If permission is still denied after request
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied");
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placemark
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
