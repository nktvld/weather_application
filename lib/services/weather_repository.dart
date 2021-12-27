import 'package:weather_app/helpers/network.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  Future<Weather> getWeatherByCity({required String city
    // required String temperatureUnit
  }) async {
    NetworkHelper networkHelper = NetworkHelper();
    var weatherData = await networkHelper.getData(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=&appid=6fd948431aaa115d7824b32dba265bba');
    return weatherData;
  }
}
