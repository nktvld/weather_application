import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherRequestFailure implements Exception {}

class NetworkHelper {
  Future<Weather> getData(String url) async {
    http.Response response = await http.Client().get(Uri.parse((url)));
    if (response.statusCode == 200) {
      final jsonDecoded = jsonDecode(response.body);
      print(jsonDecoded);
      return Weather.fromJson(jsonDecoded);
    } else {
      throw WeatherRequestFailure();
    }
  }
}
