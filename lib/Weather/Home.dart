import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/Model/model.dart';
import 'package:weather/Weather/Controller/Controller.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  /// API key
  final _weatherService = WeatherService(apiKey: 'a65d11ebe88255be060aa4a80c5b9112');
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  /// Fetch weather
  Future<void> _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString(); // Store error message
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : _errorMessage != null
            ? Text(_errorMessage!) // Display error message
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "City not found"),
            // Add more weather details here
            Text('Temperature: ${_weather?.temparature ?? "N/A"} °C'), // Example for temperature
          ],
        ),
      ),
    );
  }
}
