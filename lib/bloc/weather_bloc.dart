import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_repository.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepo;

  WeatherBloc({
    required this.weatherRepo,
  }) : super(WeatherState());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeatherByCity) {
      yield* _mapFetchWeatherByCityToState(event);
    } else if (event is FetchWeatherByLocation) {
    } else if (event is RefreshWeather) {
      yield* _mapRefreshWeatherToState(event);
    } else if (event is ResetWeather) {
      yield* _mapResetWeatherToState(event);
    }
  }

  Stream<WeatherState> _mapFetchWeatherByCityToState(event) async* {
    if (event.city == null || event.city.isEmpty) return;
    try {
      yield state.copyWith(weatherStatus: WeatherStatus.loading);

      final Weather weather = await weatherRepo.getWeatherByCity(
        city: event.city,
      );
      yield state.copyWith(
          weatherStatus: WeatherStatus.success, weather: weather);
    } on Exception {
      yield state.copyWith(weatherStatus: WeatherStatus.failure);
    }
  }

  Stream<WeatherState> _mapResetWeatherToState(event) async* {
    yield state.copyWith(weatherStatus: WeatherStatus.initial);
  }

  Stream<WeatherState> _mapRefreshWeatherToState(event) async* {
    if (!state.isSuccess) return;
    if (state.weather == Weather.empty) return;
    yield state.copyWith(weatherStatus: WeatherStatus.loading);
    try {
      final Weather weather = await weatherRepo.getWeatherByCity(
        city: state.weather.city!,
      );
      yield state.copyWith(
          weatherStatus: WeatherStatus.success, weather: weather);
    } on Exception {
      yield state.copyWith(weatherStatus: WeatherStatus.failure);
    }
  }
}
